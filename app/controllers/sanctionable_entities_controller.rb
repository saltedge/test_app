class SanctionableEntitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  skip_before_action :verify_authenticity_token
  def index
    @sanctionable_entities = SanctionableEntity.all
    @sanctionable_entities = SanctionableEntity.paginate(page: params[:page], per_page: 50)
  end

  def show
    @sanctionable_entity = SanctionableEntity.find(params[:id])
  end

  def new
    @sanctionable_entity = SanctionableEntity.new
  end

  def create
    sanctionable_entity = SanctionableEntity.new(
      sanctionable_entity_params.merge(
        creator_id: current_user.id,
        updater_id: current_user.id,
        extra:      sanctionable_entity_extra
      )
    )
    sanctionable_entity.save!
    redirect_to :sanctionable_entities
  end

  def edit
    @sanctionable_entity = SanctionableEntity.find(params[:id])
  end

  def update
    sanctionable_entity = SanctionableEntity.find(params[:id])
    sanctionable_entity.update!(
      sanctionable_entity_params.merge(
        extra:      sanctionable_entity_extra,
        updater_id: current_user.id
      )
    )
    redirect_to :sanctionable_entities
  end

  def destroy
    @sanctionable_entity = SanctionableEntity.find(params[:id])
    @sanctionable_entity.destroy

    redirect_to :sanctionable_entities
  end

  private

  def sanctionable_entity_params
    params.require(:sanctionable_entity).permit(
      :list_name,
      :official_id,
      :gender,
      :additional_info,
      :extra
    )
  end

  def sanctionable_entity_extra
    extra = JSON.parse(sanctionable_entity_params[:extra].gsub("=>", ": ")).deep_symbolize_keys
    extra
  end
end
