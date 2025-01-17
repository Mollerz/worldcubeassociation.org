# frozen_string_literal: true

class RegionalOrganizationsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action -> { redirect_to_root_unless_user(:can_manage_regional_organizations?) }, except: [:index]

  def admin
    @regional_organizations = RegionalOrganization.all.order(country: :asc)
  end

  def index
    @acknowledged_regional_organizations = RegionalOrganization.currently_acknowledged.order(country: :asc)
  end

  def new
    @regional_organization = RegionalOrganization.new
  end

  def edit
    @regional_organization = regional_organization_from_params
  end

  def update
    @regional_organization = regional_organization_from_params

    if @regional_organization.update_attributes(regional_organization_params)
      flash[:success] = "Updated Regional Organization"
      redirect_to edit_regional_organization_path(@regional_organization)
    else
      render :edit
    end
  end

  def create
    @regional_organization = RegionalOrganization.new(regional_organization_params)

    @regional_organization.logo.attach(params[:regional_organization][:logo])
    if @regional_organization.save
      flash[:success] = "Created new Regional Organization"
      redirect_to edit_regional_organization_path(@regional_organization)
    else
      @regional_organization.errors[:name].concat(@regional_organization.errors[:id])
      render :new
    end
  end

  private def regional_organization_params
    params.require(:regional_organization).permit(:name, :country, :website, :logo, :start_date, :end_date)
  end

  private def regional_organization_from_params
    RegionalOrganization.find(params[:id])
  end
end
