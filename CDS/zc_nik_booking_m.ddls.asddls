@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Bookings'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_NIK_BOOKING_M
  as projection on ZI_NIK_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.FirstName as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _carrier.Name as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _bookingStatus._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _bookingStatus,
      _booksuppl : redirected to composition child ZC_NIK_BOOKSUPPL_M,
      _carrier,
      _connection,
      _customer,
      _travel    : redirected to parent ZC_NIK_TRAVEL_M
}
