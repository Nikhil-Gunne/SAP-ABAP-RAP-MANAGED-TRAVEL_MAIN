@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_NIK_TRAVEL_M 
provider contract transactional_query
as projection on ZI_NIK_TRAVEL_M
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    AgencyId,
    _agency.Name as AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
    _customer.FirstName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'OverallStatusText' ]
    OverallStatus,
    _status._Text.Text as OverallStatusText : localized,
//    CreatedBy,
//    CreatedAt,
//    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _agency,
    _booking : redirected to composition child ZC_NIK_BOOKING_M,
    _currency,
    _customer,
    _status
}
