@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_NIK_TRAVEL_M
  as select from znik_travel_m
  composition [1..*] of ZI_NIK_BOOKING_M as _booking
  association [0..1] to /DMO/I_Agency            as _agency   on $projection.AgencyId = _agency.AgencyID
  association [0..1]    to /DMO/I_Customer          as _customer on $projection.CustomerId = _customer.CustomerID
  association [0..1]    to I_Currency               as _currency on $projection.CurrencyCode = _currency.Currency
  association [0..1]    to /DMO/I_Overall_Status_VH as _status   on $projection.OverallStatus = _status.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      //associations
      _agency,
      _customer,
      _status,
      _currency,
      _booking
}
