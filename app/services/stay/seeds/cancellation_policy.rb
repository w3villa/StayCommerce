module Stay
  module Seeds
    class CancellationPolicy
      def self.call
        policies = {
          "strict" => "Cancellation from tenant of confirmed booking; No Refund. / Cancelación del inquilino de la reserva confirmada; No hay reembolso del depósito (primer mes de renta).",
          "moderate" => "*Cancellation from tenant of confirmed booking 30 days or less before check-in date; No Refund. / Cancelación del inquilino de la reserva confirmada 30 días o menos antes de la fecha del check-in; No hay reembolso del depósito (primer mes de renta).\n\n" \
                        "*Cancellation from tenant of confirmed booking, 31 to 60 days before check-in date; 50% refund of deposit (first month rent). / Cancelación del inquilino de la reserva confirmada, de 31 a 60 días antes de la fecha del check-in; 50% de reembolso del depósito (primer mes de renta).\n\n" \
                        "*Cancellation from tenant of confirmed booking, 61 days or more before check-in date; Full refund of deposit (first month rent). / Cancelación del inquilino de la reserva confirmada, 61 días o más antes de la fecha del check-in; Reembolso total del depósito (primer mes de renta).",
          "flexible" => "Cancellation from tenant of confirmed booking 15 days or less before check-in date; No Refund. / Cancelación del inquilino de la reserva confirmada, 15 días o menos antes de la fecha del check-in; No hay reembolso del depósito (primer mes de renta).\n\n" \
                        "Cancellation from tenant of confirmed booking, 16 to 30 days before check-in date; 50% refund of deposit (first month rent). / Cancelación del inquilino de la reserva confirmada, de 16 a 30 días antes de la fecha del check-in; 50% de reembolso del depósito (primer mes de renta).\n\n" \
                        "Cancellation from tenant of confirmed booking, 31 days or more before check-in date; Full refund of deposit (first month rent). / Cancelación del inquilino de la reserva confirmada, 31 días o más antes de la fecha del check-in; Reembolso total del depósito (primer mes de renta)."
        }

        policies.each do |name, description|
          Stay::CancellationPolicy.find_or_create_by!(name: name, description: description)
        end
      end
    end
  end
end
