@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for booking APPROVER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_NIK_BKNG_APP_M as projection on ZI_NIK_BOOKING_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _bookingStatus,
    _booksuppl,
    _carrier,
    _connection,
    _customer,
    _travel : redirected to parent ZC_NIK_TRAVEL_APP_M
}
