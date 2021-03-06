class ConnectionsController < ApplicationController

  def edit
    if params[:from_port_id].present? && params[:from_port_id].to_i > 0
      @from_port = Port.find_by_id(params[:from_port_id])
    else
      @from_port = Port.create(position: params['position'],
                          card_id: params['card_id'],
                          vlans: params['vlans'],
                          color: params['color'],
                          cablename: params['cablename'])
    end

    @frame = @from_port.server.frame
    @room = @frame.room
    @from_server = @from_port.server

    @coupled_frames = @frame.bay.frames
    @possible_destination_servers = []
    @coupled_frames.each do |frame|
      @possible_destination_servers << [frame.name, frame.servers.collect {|v| [ v.name, v.id ] }]
    end

    # Destination port
    if @from_port.connection.present? && @from_port.connection.cable.present?
      @cable = @from_port.connection.cable
    end

    @to_port = @cable.connections.reject{|conn| conn.port_id.to_i == @from_port.id }.first.try(:port) if @cable.present?

    # Destination server
    @to_server = @to_port.present? ? @to_port.server : @frame.servers.where.not(position: nil, modele_id: nil).order(:position).first
    @to_server.create_missing_ports
    @to_server.reload

  end

  def update
    from_port = Port.find(params[:connection][:from_port_id])
    to_port = Port.find(params[:connection][:to_port_id])

    from_port.connect_to_port(to_port,
                              params[:connection][:cablename],
                              params[:connection][:color],
                              params[:connection][:vlans])

    @from_server = from_port.server
    @to_server = to_port.server

    respond_to do |format|
      format.html { redirect_to connections_edit_path(from_port_id: from_port.id), notice: 'La connexion a été mise à jour.' }
      format.js
    end
  end

  def update_destination_server
    @server = Server.find_by_id(params[:server_id])
    @server.create_missing_ports
    @server.reload
  end

end
