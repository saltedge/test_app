describe Api::V1::SanctionsController do
  before do
    request.headers["HTTP_APP_SECRET"] = Settings.external_app.external_app_to_test_app_secret
    request.content_type = "application/json"
  end

  describe "POST #check_persons" do
    let!(:check_persons_params) { JSON.parse(load_fixture("controllers/api/v1/sanctions/check_persons_request.json")) }

    it "should do sanctions check and return result (match false)" do
      post :check_persons, params: check_persons_params
      parsed_response.should == JSON.parse(load_fixture("controllers/api/v1/sanctions/results/result_without_match.json"))
    end

    it "should do sanctions check and return result (match true)" do
      sanctionable_person_1 = create :sanctionable_entity
      sanctionable_person_2 = create :sanctionable_entity, gender: "F", extra: {
        birth_datas:  [{ date: "2000-01-01" }],
        citizenships: [{ country_code: "MD" }],
        name_aliases: [{ full_name: "alice doe"}]
      }

      post :check_persons, params: check_persons_params
      parsed_response.should == JSON.parse(load_fixture("controllers/api/v1/sanctions/results/result_with_match.json"))
    end

    it "should return MissingRequiredFields error" do
      check_persons_params["data"].delete("list_of_persons")
      post :check_persons, params: check_persons_params

      result = parsed_response
      result["error_class"].should == "MissingRequiredFields"
      result["message"].should     == "[\"list_of_persons\"]"
      result["status"].should      == "not_acceptable"
    end

    it "should return ListOfPersonsLimitExceeded error" do
      check_persons_params["data"]["list_of_persons"] += [{}, {}, {}]
      post :check_persons, params: check_persons_params

      result = parsed_response
      result["error_class"].should == "ListOfPersonsLimitExceeded"
      result["message"].should     == "API: Too much persons. Max: 3"
      result["status"].should      == "not_acceptable"
    end

    it "should return error when app secret is not valid" do
      subject.request.headers.merge("HTTP_APP_SECRET" => "wrong_secret")
      post :check_persons, params: check_persons_params

      result = parsed_response
      result["error_class"].should == "ExternalAppSecretInvalid"
      result["message"].should     == "Wrong external_app_to_test_app"
      result["status"].should      == "not_acceptable"
    end

    it "should return error when app secret is nil" do
      subject.request.headers.merge("HTTP_APP_SECRET" => nil)
      post :check_persons, params: check_persons_params

      result = parsed_response
      result["error_class"].should == "AppSecretNotReceived"
      result["message"].should     == "Missing HTTP_APP_SECRET header in request."
      result["status"].should      == "not_acceptable"
    end
  end
end