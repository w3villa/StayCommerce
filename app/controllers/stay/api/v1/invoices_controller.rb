class Stay::Api::V1::InvoicesController < ApplicationController
  before_action :authenticate_devise_api_token!

  def index
    invoices = Stay::Invoice.joins(booking: :property)
                            .where(stay_properties: { user: current_devise_api_user })

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      invoices = invoices.where(
        "stay_bookings.check_in_date >= :start_date AND stay_bookings.check_out_date <= :end_date",
        start_date: start_date,
        end_date: end_date
      )
    end

    if params[:type].present?
      invoices = invoices.where("invoice_type LIKE ?", "%#{params[:type]}%")
    end

    if params[:status].present?
      case params[:status]
      when "confirmed"
        invoices = invoices.where("stay_bookings.status = ?", "confirmed")
      when "any"
        invoices = invoices.where("stay_bookings.status = ?", "invoice_sent")
      end
    end

    if invoices.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(invoices, each_serializer: InvoiceSerializer), success: true }, status: :ok
    else
      render json: { error: "no invoice found", success: false }, status: :unprocessable_entity
    end
  end


  def show
    invoice = Stay::Invoice.find_by(id: params[:id])
    if invoice.present?
      render json: { data: ActiveModelSerializers::SerializableResource.new(invoice, serializer: InvoiceSerializer), success: true }, status: :ok
    else
      render json: { error: "no invoice found", success: false }, status: :unprocessable_entity
    end
  end
end
