pageextension 50121 "PCO Sales Order List" extends "Sales Order List"
{
    actions
    {
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                CheckRequestedDeliveryDate();
            end;
        }
    }

    local procedure CheckRequestedDeliveryDate()
    var
        MissingValueErr: Label 'Requested delivery date requires a value.';
        MissingReqDeliveryDateLbl: Label 'Missing Requested Delivery Date';
        ReqDeliveryDateErrorInfo: ErrorInfo;
    begin
        case true of
            Rec.Status = Enum::"Sales Document Status"::Released,
            Rec."Requested Delivery Date" <> 0D:
                exit;
        end;

        // Define the error
        ReqDeliveryDateErrorInfo := ErrorInfo.Create(MissingValueErr);
        ReqDeliveryDateErrorInfo.Title := MissingReqDeliveryDateLbl;

        // Add actions to error message
        ReqDeliveryDateErrorInfo.AddNavigationAction();

        // Add record ID since we will need that for our actions
        ReqDeliveryDateErrorInfo.RecordId := Rec.RecordId();

        // Throw the error
        Error(ReqDeliveryDateErrorInfo);
    end;
}
