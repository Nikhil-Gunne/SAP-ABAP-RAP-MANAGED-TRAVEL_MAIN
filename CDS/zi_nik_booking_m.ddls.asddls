@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_NIK_BOOKING_M
  as select from znik_booking_m
  composition [0..*] of ZI_NIK_BOOKSUPPL_M as _booksuppl
  
  association to parent ZI_NIK_TRAVEL_M as _travel
  on $projection.TravelId = _travel.TravelId
  association [1] to /DMO/I_Carrier           as _carrier       on  $projection.CarrierId = _carrier.AirlineID
  association [1] to /DMO/I_Customer          as _customer      on  $projection.CustomerId = _customer.CustomerID
  association [1] to /DMO/I_Connection        as _connection    on  $projection.CarrierId    = _connection.AirlineID
                                                                and $projection.ConnectionId = _connection.ConnectionID
  association [1] to /DMO/I_Booking_Status_VH as _bookingStatus on  $projection.BookingStatus = _bookingStatus.BookingStatus

{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      //associations
      _carrier,
      _customer,
      _connection,
      _bookingStatus,
      _travel,
      _booksuppl
}
