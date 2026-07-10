@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Booking supplement'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_NIK_BOOKSUPPL_M as projection on ZI_NIK_BOOKSUPPL_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplDesc' ]
    SupplementId,
    _supplementText.Description as SupplDesc :localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _booking : redirected to parent ZC_NIK_BOOKING_M,
    _supplement,
    _supplementText,
    _travel : redirected to ZC_NIK_TRAVEL_M
}
