codeunit 50120 "PCO Sales Order Errors"
{
    procedure FillRequestedDeliveryDateWithWorkDate(ErrorInfo: ErrorInfo)
    begin
        FillRequestDate(ErrorInfo, WorkDate());
    end;

    procedure FillRequestedDeliveryDateWithCurrentDate(ErrorInfo: ErrorInfo)
    begin
        FillRequestDate(ErrorInfo, Today());
    end;

    local procedure FillRequestDate(ErrorInfo: ErrorInfo; RequestDateValue: Date)
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderRecordRef: RecordRef;
    begin
        SalesHeaderRecordRef.Get(ErrorInfo.RecordId());
        SalesHeaderRecordRef.SetTable(SalesHeader);

        SalesHeader.Validate("Requested Delivery Date", RequestDateValue);
    end;
}
