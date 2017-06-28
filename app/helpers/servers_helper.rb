module ServersHelper
  def calculate_ports_sums(frame, servers)
    # sums per frame and per type of port
    sums = { frame.id => {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0} }

    servers.each do |server|
      server.ports_per_type.each do |type, sum|
        sums[frame.id][type] = sums[frame.id][type].to_i + sum
      end
    end

    sums
  end

  def port_cablename(port_data)
    if port_data.present? && port_data.cablename.present?
      port_data.cablename
    else
      ""
    end
  end

  def ports_by_card(port_type:, port_quantity:, ports_data:, cards_server_id:)
    html = ""
    port_quantity.to_i.times do |index|
      port_data = ports_data.detect {|p| p.position == index+1}
      html += link_to_port(index+1, port_data, port_type, cards_server_id)
    end
    html.html_safe
  end

  def link_to_port(position, port_data, port_type, cards_server_id)
    edit_port_url = port_data.try(:id) ? edit_port_path(port_data) : edit_port_path(id: 0, cards_server_id: cards_server_id, position: position)

    case port_type.name
      when 'RJ'
        link_to port_cablename(port_data),
                        edit_port_url,
                        class: "port pull-left portRJ #{port_data.present? ? port_data.color : '' }",
                        data: {url: edit_port_url,
                               position: position,
                               type: "RJ",
                               toggle: 'tooltip',
                               placement: 'top',
                               title: port_data.present? ? "#{port_data.vlans}" : ""
                        }

      when 'FC'
        link_to port_cablename(port_data),
                        edit_port_url,
                        class: "port pull-left portFC #{port_data.present? ? port_data.color : '' }",
                        data: {url: edit_port_url,
                               position: position,
                               type: "FC",
                               toggle: 'tooltip',
                               placement: 'top',
                               title: port_data.present? ? "#{port_data.vlans}" : ""
                        }

      else
        link_to "#{port_type.try(:name)}<BR>#{port_cablename(port_data)}".html_safe,
                        edit_port_url,
                        class: "port pull-left portSCSI #{port_data.present? ? port_data.color : '' }",
                        data: {url: edit_port_url,
                               position: position,
                               type: port_type.try(:name),
                               toggle: 'tooltip',
                               placement: 'top',
                               title: port_data.present? ? "#{port_data.vlans}" : ""
                        }


    end
  end

  def get_ports_per_bay_on_a_server(bay_id:, server:)
    Port.joins('INNER JOIN "cards_servers" ON "ports"."cards_server_id" = "cards_servers"."id"')
        .joins('INNER JOIN "cards" ON "cards_servers"."card_id" = "cards"."id"')
        .joins('INNER JOIN "port_types" ON "cards"."port_type_id" = "port_types"."id" AND  "port_types".name <> \'SAS\'')
        .joins('INNER JOIN "servers" ON "servers".id = "cards_servers"."server_id"')
        .joins('INNER JOIN "frames" ON "frames".id = "servers"."frame_id" AND "bay_id" = '+ bay_id.to_s)
        .includes(:cards_server)
        .where('substring(cablename from \'.\') IN (?)', server.cards_servers.map(&:connections_identifier).uniq.compact)
        .order('cablename asc')

  end

end
