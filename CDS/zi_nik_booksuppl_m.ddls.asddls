@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for booking supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_NIK_BOOKSUPPL_M as select from znik_booksuppl_m
association to parent ZI_NIK_BOOKING_M as _booking
on $projection.TravelId = _booking.TravelId 
and $projection.BookingId = _booking.BookingId
association [1..1] to  ZI_NIK_TRAVEL_M as _travel
on $projection.TravelId = _travel.TravelId
association [1] to /DMO/I_Supplement as _supplement
on $projection.SupplementId = _supplement.SupplementID
association [1..*] to /DMO/I_SupplementText as _supplementText
on $projection.SupplementId = _supplementText.SupplementID

{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    
    //associations
    
    _supplement,
    _supplementText,
    _booking,
    _travel
    
    
}
