require File.expand_path("../../test_helper", __FILE__)

class ServersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    Server.find_each(&:save)
    @server = servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, params:{server: { cluster_id: @server.cluster_id, conso: @server.conso, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero.to_s+'_bis', rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id }}
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test "should NOT create server with existing serial number" do
    assert_no_difference('Server.count') do
      post :create, params: {server: { cluster_id: @server.cluster_id, conso: @server.conso, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id }}
    end
  end

  test "should show server" do
    get :show, params: {id: @server}
    assert_response :success
    assert_select 'dt', "Position:"
  end

  test "should show server using id" do
    get :show, params: {id: @server.id}
    assert_response :success
  end

  test "should show server using their name" do
    get :show, params: {id: @server.name}
    assert_response :success
  end

  test "should show server using serial number" do
    get :show, params: {id: @server.numero}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @server}
    assert_response :success
  end

  test "should update server" do
    patch :update, params: {id: @server, server: { cluster: @server.cluster, conso: @server.conso, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id }}
    assert_redirected_to server_path(assigns(:server))
  end

  test "should rename a server" do
    new_name = "NewServerName"
    old_name = @server.name
    patch :update, params: {id: @server, server: { name: new_name }}
    assert_redirected_to server_path(assigns(:server))

    # test new name
    response = get :show, params: {id: new_name}
    assert_response :success
    assert_equal assigns(:server), @server

    #old name should continue to work
    get :show, params: {id: old_name}
    assert_response :success
    assert_equal assigns(:server), @server
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, params: {id: @server}
    end

    assert_redirected_to servers_grids_path
  end
end
