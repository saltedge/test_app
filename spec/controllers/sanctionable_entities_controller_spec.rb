describe SanctionableEntitiesController do
  let!(:user)                  { create :user }
  let!(:sanctionable_entity_1) { create :sanctionable_entity }
  let!(:sanctionable_entity_2) { create :sanctionable_entity }
  let!(:sanctionable_entity_3) { create :sanctionable_entity }

  before { sign_in user }

  describe "POST #create" do
    let(:params) do
      {
        "list_name"   => "UN",
        "official_id" => "UN.1234",
        "gender"      => "F",
        "extra"       => {
          "birth_datas"  => [{ "date" => "1999-12-31" }],
          "citizenships" => [{ "country_code" => "MD" }],
          "name_aliases" => [{ "full_name" => "alice doe" }]
        }.to_json
      }
    end

    it "should create sanctionable entity" do
      expect {
        post :create, params: {
          "sanctionable_entity" => params,
          "controller" => "sanctionable_entities",
          "action" => "create"
        }
      }.to change { SanctionableEntity.count }.by(1)
    end
  end

  describe "PUT #update" do
    let(:params) do
      {
        "sanctionable_entity" => {
          "id"          => sanctionable_entity_1.id,
          "official_id" => "EU.9999",
          "extra"       => { "birth_datas" => [{ "date" => "1999-12-31" }] }.to_json
        },
        "id" => sanctionable_entity_1.id
      }
    end

    it "updates sanctionable entity" do
      official_id = sanctionable_entity_1.official_id

      expect {
        put :update, params: params
      }.to change { sanctionable_entity_1.reload.official_id }.from(official_id).to("EU.9999")
    end
  end

  describe "DELETE #destroy" do
    it "deletes sanctionable entity" do
      expect { delete :destroy, params: { id: sanctionable_entity_3.id } 
    }.to change { SanctionableEntity.count }.by(-1)
    end
  end
end
