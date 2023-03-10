codeunit 50120 "PCO Sales Order Errors"
{
    procedure FillRequestedDeliveryDateWithWorkDate(ThrownErrorInfo: ErrorInfo)
    begin
        FillRequestDate(ThrownErrorInfo, WorkDate());
    end;

    procedure FillRequestedDeliveryDateWithCurrentDate(ThrownErrorInfo: ErrorInfo)
    begin
        FillRequestDate(ThrownErrorInfo, Today());
    end;

    local procedure FillRequestDate(ThrownErrorInfo: ErrorInfo; RequestDateValue: Date)
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderRecordRef: RecordRef;
    begin
        SalesHeaderRecordRef.Get(ThrownErrorInfo.RecordId());
        SalesHeaderRecordRef.SetTable(SalesHeader);

        SalesHeader.Validate("Requested Delivery Date", RequestDateValue);
    end;
}