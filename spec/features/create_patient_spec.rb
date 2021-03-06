require 'rails_helper'

RSpec.describe 'creating a Patient', type: :feature do
  let(:patient)                                         { build_stubbed :patient }

  let(:first_name)                                      { patient.first_name }
  let(:last_name)                                       { patient.last_name }
  let(:cellphone_number)                                { patient.cellphone_number }
  let(:address)                                         { patient.address }
  let(:email)                                           { patient.email }
  let(:relative_cellphone_number)                       { patient.relative_cellphone_number }
  let(:general_practitioner)                            { patient.general_practitioner }
  let(:covid_general_practitioner)                      { patient.covid_general_practitioner }
  let(:gender)                                          { patient.gender }
  let(:birthdate)                                       { patient.birthdate }
  let(:is_healthcare_professional)                      { patient.is_healthcare_professional }
  let(:pregnant)                                        { patient.pregnant }
  let(:home_caregivers)                                 { patient.home_caregivers }
  let(:home_caregivers_type)                            { patient.home_caregivers_type }
  let(:covid_initial_symptom)                           { patient.covid_initial_symptom }
  let(:covid_initial_symptoms_diagnosed_on)             { patient.covid_initial_symptoms_diagnosed_on }
  let(:covid_initial_symptoms_started_on)               { patient.covid_initial_symptoms_started_on }
  let(:covid_treatment_started_on)                      { patient.covid_treatment_started_on }
  let(:interstitial_alveolus_infiltrates)               { patient.interstitial_alveolus_infiltrates }
  let(:notable_long_term_treatments)                    { patient.notable_long_term_treatments }
  let(:sars_cov_2_treatment)                            { patient.sars_cov_2_treatment }
  let(:sars_cov_2_treatment_name)                       { patient.sars_cov_2_treatment_name }
  let(:home_follow_up_elligible)                        { patient.home_follow_up_elligible }

  let(:comorbidity_smoking)                             { patient.comorbidity_smoking }

  let!(:command_center)                                 { create :command_center }
  let!(:other_command_center)                           { create :command_center }

  describe 'Creating a Patient', js: true do
    context 'authenticated' do
      let(:admin_user) { create :admin_user }

      before(:each) do
        admin_sign_in_with(admin_user)
      end

      context 'with valid attributes' do
        xit 'creates the Patient', js: true do
          visit new_patient_path

          select command_center.name, from: :create_patient_form_command_center_id

          fill_in :create_patient_form_cellphone_number, with: cellphone_number
          fill_in :create_patient_form_first_name, with: first_name
          fill_in :create_patient_form_last_name, with: last_name
          select "Masculin", from: :create_patient_form_gender
          fill_in :create_patient_form_birthdate, with: birthdate #TODO: fix fucking JS
          select "Non", from: :create_patient_form_pregnant

          choose(:create_patient_form_comorbidity_chronic_cardiac_disease_false)
          choose(:create_patient_form_comorbidity_chronic_pulmonary_disease_false)
          choose(:create_patient_form_comorbidity_asthma_false)
          choose(:create_patient_form_comorbidity_chronic_kidney_disease_false)
          choose(:create_patient_form_comorbidity_liver_disease_false)
          choose(:create_patient_form_comorbidity_mild_liver_disease_false)
          choose(:create_patient_form_comorbidity_chronic_neurological_disorder_false)
          choose(:create_patient_form_comorbidity_malignant_neoplasia_false)
          choose(:create_patient_form_comorbidity_malnutrition_false)
          choose(:create_patient_form_comorbidity_chronic_hemathological_disease_false)
          choose(:create_patient_form_comorbidity_hiv_false)
          choose(:create_patient_form_comorbidity_obesity_false)
          choose(:create_patient_form_comorbidity_diabetes_with_complications_false)
          choose(:create_patient_form_comorbidity_diabetes_false)
          choose(:create_patient_form_comorbidity_rheumatologic_disease_false)
          choose(:create_patient_form_comorbidity_dementia_false)
          choose(:create_patient_form_comorbidity_smoking_yes)

          fill_in :create_patient_form_covid_initial_symptoms_started_on, with: covid_initial_symptoms_started_on #TODO: fix fucking JS

          select "Non", from: :create_patient_form_sars_cov_2_treatment
          select "Non", from: :create_patient_form_home_caregivers

          expect {
            click_on 'Créer'
            save_and_open_page
          }.to change(Patient, :count).by(1)

          patient = Patient.last

          expect(patient.command_center).to eq command_center
        end
      end
    end

    context 'unauthenticated' do
      it 'prevents the Patient creation' do
        visit new_patient_path

        expect(body).to have_content('Vous devez vous connecter ou vous inscrire pour continuer.')
      end
    end
  end
end