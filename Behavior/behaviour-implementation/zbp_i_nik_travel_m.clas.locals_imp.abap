CLASS lsc_zi_nik_travel_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_nik_travel_m IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_logs TYPE TABLE OF znik_log,
           ls_logs TYPE znik_log.
*           lt_logs_temp LIKE lt_logs.

    IF create-zi_nik_travel_m IS NOT INITIAL.

*      lt_logs = CORRESPONDING #( create-zi_nik_travel_m ).

      LOOP AT create-zi_nik_travel_m ASSIGNING FIELD-SYMBOL(<fs_create_travel>).
*        READ TABLE lt_logs WITH KEY travelid = <fs_create_travel>-TravelId
*                            ASSIGNING FIELD-SYMBOL(<fs_logs>).
        IF <fs_create_travel>-%control-BookingFee = '01'.
          ls_logs-changed_field_name = 'BookingFee'.
          ls_logs-changed_value = <fs_create_travel>-BookingFee.
          ls_logs-changing_operation = 'Create'.
          ls_logs-created_at = <fs_create_travel>-CreatedAt.
          ls_logs-user_responsible = <fs_create_travel>-CreatedBy.
          ls_logs-travelid = <fs_create_travel>-TravelId.
          TRY.
              ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.
*          APPEND <fs_logs> TO lt_logs_temp.
          APPEND ls_logs TO lt_logs.
          CLEAR : ls_logs.
        ENDIF.

        IF <fs_create_travel>-%control-CustomerId = '01'.

          ls_logs-travelid = <fs_create_travel>-TravelId.
          ls_logs-changed_field_name = 'CustomerId'.
          ls_logs-changed_value = <fs_create_travel>-CustomerId.
          ls_logs-changing_operation = 'Create'.
          ls_logs-created_at = <fs_create_travel>-CreatedAt.
          ls_logs-user_responsible = <fs_create_travel>-CreatedBy.
*          <fs_logs>-changed_field_name = 'CustomerId'.
*          <fs_logs>-changed_value = <fs_create_travel>-CustomerId.
*          <fs_logs>-changing_operation = 'Create'.
*          <fs_logs>-created_at = <fs_create_travel>-CreatedAt.
*          <fs_logs>-user_responsible = <fs_create_travel>-CreatedBy.
          TRY.
              ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static( ).
*              <fs_logs>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.
          APPEND ls_logs TO lt_logs.
*          APPEND <fs_logs> TO lt_logs_temp.
          CLEAR : ls_logs.
        ENDIF.
      ENDLOOP.

*      INSERT znik_log FROM TABLE @lt_logs_temp.
      INSERT znik_log FROM TABLE @lt_logs.
      CLEAR : lt_logs.
    ENDIF.

    IF update-zi_nik_travel_m IS NOT INITIAL.

      TYPES : tt_keys TYPE TABLE OF znik_log WITH NON-UNIQUE KEY travelid.
      DATA(lt_keys) = CORRESPONDING tt_keys( update-zi_nik_travel_m ).

*     reading from transactional buffer getting updated values
*    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
*    entity zi_nik_travel_m
*    ALL FIELDS
*    WITH CORRESPONDING #( lt_keys )
*    RESULT DATA(lt_travels).

      IF lt_keys IS NOT INITIAL.
        SELECT
        FROM znik_travel_m
        FIELDS *
        FOR ALL ENTRIES IN @lt_keys
        WHERE travel_id = @lt_keys-travelid
        INTO TABLE @DATA(lt_travels).
      ENDIF.

      SORT lt_travels BY travel_id ASCENDING.

      LOOP AT update-zi_nik_travel_m ASSIGNING FIELD-SYMBOL(<fs_update>).

        READ TABLE lt_travels ASSIGNING FIELD-SYMBOL(<fs_trv>)
                              WITH KEY travel_id = <fs_update>-TravelId
                              BINARY SEARCH.
        ls_logs = CORRESPONDING #(
                    <fs_update>
                    MAPPING
                    travelid = TravelId
                    created_at = LastChangedAt
                    user_responsible = LastChangedBy

            ).

        IF <fs_update>-%control-CustomerId = '01'."if_abap_behv=>mk-on.


          ls_logs-changed_field_name = 'CustomerId'.
          ls_logs-changing_operation = 'UPDATE'.
          ls_logs-changed_value = <fs_update>-CustomerId.
          ls_logs-previous_value = <fs_trv>-customer_id.
          TRY.
              ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.

          APPEND ls_logs TO lt_logs.
*        clear : ls_logs.
        ENDIF.

        IF <fs_update>-%control-AgencyId = '01'."if_abap_behv=>mk-on.
*        ls_logs = CORRESPONDING #(
*                <fs_update>
*                MAPPING
*                travelid = TravelId
*                created_at = LastChangedAt
*                user_responsible = LastChangedBy
*
*        ).
*
          ls_logs-changed_field_name = 'Agency Id'.
          ls_logs-changing_operation = 'UPDATE'.
          ls_logs-changed_value = <fs_update>-AgencyId.
          ls_logs-previous_value = <fs_trv>-agency_id.
          TRY.
              ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.

          APPEND ls_logs TO lt_logs.
*        clear : ls_logs.
        ENDIF.

        IF <fs_update>-%control-BookingFee = '01'."if_abap_behv=>mk-on.


          ls_logs-changed_field_name = 'BookingFee'.
          ls_logs-changing_operation = 'UPDATE'.
          ls_logs-changed_value = <fs_update>-BookingFee.
          "example for read table short hand syntax.
          ls_logs-previous_value = lt_travels[ travel_id = <fs_update>-TravelId  ]-booking_fee.
          TRY.
              ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.

          APPEND ls_logs TO lt_logs.
        ENDIF.
        CLEAR : ls_logs.


      ENDLOOP.

      INSERT znik_log FROM TABLE @lt_logs.
      CLEAR : lt_logs.


    ENDIF.

    IF delete-zi_nik_travel_m IS NOT INITIAL.

      LOOP AT delete-zi_nik_travel_m INTO DATA(ls_delete).
        ls_logs-travelid = ls_delete-TravelId.
        ls_logs-changing_operation = 'DELETE'.
        GET TIME STAMP FIELD ls_logs-created_at.
        ls_logs-user_responsible = cl_abap_context_info=>get_user_technical_name( ).
        TRY.
            ls_logs-change_id = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.
        APPEND ls_logs to lt_logs.
        clear ls_logs.

      ENDLOOP.
      insert znik_log FROM TABLE @lt_logs.
      CLEAR : lt_logs.



    ENDIF.



  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_NIK_TRAVEL_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_nik_travel_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_nik_travel_m RESULT result.
    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_nik_travel_m~copytravel.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_nik_travel_m~accepttravel RESULT result.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_nik_travel_m~rejecttravel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_nik_travel_m RESULT result.
    METHODS validatecustomerid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_nik_travel_m~validatecustomerid.
    METHODS validateagencyid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_nik_travel_m~validateagencyid.
    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_nik_travel_m~recalctotalprice.
    METHODS determinetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_nik_travel_m~determinetotalprice.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_nik_travel_m\_booking.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_nik_travel_m.

ENDCLASS.

CLASS lhc_ZI_NIK_TRAVEL_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.

    DELETE  lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*      ignore_buffer     =
            nr_range_nr       = '01' "01
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*
          IMPORTING
            number            =  DATA(lv_number)
            returncode        =  DATA(lv_code)
            returned_quantity =  DATA(lv_returned)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #(  %cid = ls_entities-%cid
                           %key = ls_entities-%key ) TO failed-zi_nik_travel_m.
          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
                          %msg = lo_error
          ) TO reported-zi_nik_travel_m.

        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_returned = lines( lt_entities ).

    DATA(lv_currNumber) = lv_number - lv_returned.

*  DATA: lt_travel_mapped type table for mapped early zi_nik_travel_m,
*       ls_travel_mapped like line of lt_travel_mapped.
    LOOP AT lt_entities INTO ls_entities.
      lv_currNumber = lv_currNumber + 1.

*  ls_entities-TravelId = lv_currNumber.

*  ls_travel_mapped  = value #(  %cid = ls_entities-%cid
*                                TravelId = lv_currnumber
*   ).

*  APPEND ls_travel_mapped to mapped-zi_nik_travel_m.

      APPEND VALUE #(  %cid = ls_entities-%cid
                                    TravelId = lv_currnumber
       ) TO mapped-zi_nik_travel_m.


    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
*  DATA(lt_entities) = entities."current instance of the booking entity.
    "to assign a booking id we need to know the maximum booking id assigned inside the travelid.

    DATA(lv_MaxBookingId) = CONV /dmo/booking_id( '0' ).

    "Reading entity by associations to get all the related bookings of a travelIds.
    "specifically use read by association as we get data by passing travelid and get all bookings.
    "to use read by entity on zi_booking_m we need to pass complete key with travelid and booking id.
    "it is more useful to use associaitons and get all the bookings by passing travelid rather than loopin
    "on all entities and pass travelid and booking id.


*  READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
*  ENTITY zi_nik_travel_m by \_booking
*  FROM CORRESPONDING #( entities )
*  RESULT DATA(lt_entities) "result just gives the booking ids of the parent in case of creation request
*  FAILED DATA(lt_failed).   for multiple entities it will be difficult to identify the parent of each booking

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m BY \_booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_ent_link) "link gives the source and target which will be useful for identifying which booking id
    FAILED DATA(lt_failed). "belongs to which travlid.


*  LOOP on entities received in importing for method
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_grp_entities>)
                        GROUP BY <fs_grp_entities>-TravelId.
      "Find current maximum BookingId of the Travel from existing bookings.
      lv_MaxBookingId = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                  FOR ls_ent_link IN lt_ent_link USING KEY entity
                                  WHERE ( source-TravelId = <fs_grp_entities>-TravelId )
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_ent_link-target-BookingId
                                                                      THEN  ls_ent_link-target-BookingId
                                                                      ELSE lv_max ) ).
      "Find maximum BookingId among incoming Booking entities to avoid
      "duplicate numbering during the same RAP transaction (e.g. drafts).
      lv_MaxBookingId = REDUCE #( INIT lv_max1 = lv_MaxBookingId
                                  FOR ls_entities IN entities USING KEY entity
                                  WHERE ( TravelId =  <fs_grp_entities>-TravelId )
                                  FOR ls_target IN ls_entities-%target
                                  NEXT lv_max1 = COND /dmo/booking_id( WHEN lv_max1 < ls_target-BookingId
                                                                       THEN  ls_target-BookingId
                                                                       ELSE lv_max1 ) ).
      "Iterate over all new Bookings of the current Travel, generate missing BookingIds,
      "and return them through MAPPED as the incoming entities are read-only.

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_ent>)
                       USING KEY entity
                       WHERE TravelId = <fs_grp_entities>-TravelId.
        LOOP AT <fs_ent>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).
          APPEND CORRESPONDING #( <fs_target> ) TO mapped-zi_nik_booking_m  ASSIGNING FIELD-SYMBOL(<fs_final>).
          IF <fs_target>-BookingId IS INITIAL.
            lv_MaxBookingId = lv_MaxBookingId + 10.
            <fs_final>-BookingId = lv_MaxBookingId.
          ENDIF.

        ENDLOOP.

      ENDLOOP.





    ENDLOOP.



  ENDMETHOD.

  METHOD copyTravel.
    "for creating copy
    DATA : it_travel_c    TYPE TABLE FOR CREATE zi_nik_travel_m,
           it_booking_cba TYPE TABLE FOR CREATE zi_nik_travel_m\_booking,
           it_booksuppl_c TYPE TABLE FOR CREATE zi_nik_booking_m\_booksuppl.
    "NEED TO CHECK %CID IS NOT INITIAL IN KEYS TABLE.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>)
                    WITH KEY %cid = ' '.

    ASSERT <fs_keys> IS NOT ASSIGNED.



    "we get the keys as importing parameter to method
    "keys table has %cid value and travelId.
    "Read entity based on the keys
    "as travel is business object we need to create a copy of child
    "entities as well.

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m BY \_booking
    ALL FIELDS
    WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_booking_m BY \_booksuppl
    ALL FIELDS
    WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksuppl_r).

    "for filling create table
    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<fs_travel_r>).

      APPEND INITIAL LINE TO it_travel_c ASSIGNING FIELD-SYMBOL(<fs_travel_c>).
      <fs_travel_c>-%cid = keys[ KEY entity TravelId = <fs_travel_r>-TravelId ]-%cid .

      <fs_travel_c>-%data = CORRESPONDING #( <fs_travel_r> EXCEPT TravelId ).


      <fs_travel_c>-%data-BeginDate = cl_abap_context_info=>get_system_date( ).
      <fs_travel_c>-%data-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <fs_travel_c>-%data-OverallStatus = 'O'.


      APPEND VALUE #( %cid_ref = <fs_travel_c>-%cid ) TO it_booking_cba
                 ASSIGNING FIELD-SYMBOL(<fs_booking_c>).
      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<fs_booking_r>)
                           USING KEY entity
                           WHERE TravelId = <fs_travel_r>-TravelId.

        APPEND CORRESPONDING #( <fs_booking_r> ) TO  <fs_booking_c>-%target ASSIGNING FIELD-SYMBOL(<fs_bk>).
        <fs_bk>-%cid = <fs_travel_c>-%cid && <fs_booking_r>-BookingId.
        <fs_bk>-BookingDate = cl_abap_context_info=>get_system_date( ).
        <fs_bk>-BookingStatus = 'N'.
        CLEAR : <fs_bk>-TravelId,<fs_bk>-BookingId.

        APPEND VALUE #( %cid_ref = <fs_bk>-%cid )
                      TO it_booksuppl_c ASSIGNING FIELD-SYMBOL(<fs_booksuppl_c>).
        LOOP AT lt_booksuppl_r ASSIGNING FIELD-SYMBOL(<fs_booksuppl_r>)
                               USING KEY entity
                               WHERE TravelId = <fs_travel_r>-TravelId
                               AND BookingId = <fs_booking_r>-BookingId.


          APPEND CORRESPONDING #( <fs_booksuppl_r> ) TO <fs_booksuppl_c>-%target
                 ASSIGNING FIELD-SYMBOL(<fs_bk_suppl>).
          <fs_bk_suppl>-%cid = <fs_travel_c>-%cid && <fs_booking_r>-BookingId && <fs_booksuppl_r>-BookingSupplementId.
          CLEAR : <fs_bk_suppl>-TravelId,<fs_bk_suppl>-BookingId,<fs_bk_suppl>-BookingSupplementId .


        ENDLOOP.


      ENDLOOP.

    ENDLOOP.


    MODIFY ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    CREATE
    FIELDS  ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
    WITH it_travel_c
    ENTITY zi_nik_travel_m
    CREATE BY \_booking
    FIELDS ( BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH it_booking_cba
    ENTITY zi_nik_booking_m
    CREATE BY \_booksuppl
    FIELDS ( SupplementId Price CurrencyCode )
    WITH it_booksuppl_c
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    mapped-zi_nik_travel_m = lt_mapped-zi_nik_travel_m.



  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
        FOR ls_keys IN keys (
                        %tky = ls_keys-%tky
                        OverallStatus = 'A'
                        )
                        )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    ALL FIELDS
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky ) )
    RESULT DATA(lt_data).

    result = VALUE #( FOR ls_data IN lt_data ( %tky = ls_data-%tky
                                               %param =  ls_data ) ).



  ENDMETHOD.

  METHOD rejectTravel.

    "WITH KEYS RECEIVED UPDATE THE FIELD OVERALLSTATUS TO CANCELLED.

    MODIFY ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys
                      ( %tky = ls_keys-%tky
                        OverallStatus = 'X'
                       )
                       )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    "READ THE ENTITY WITH KEYS RECEIVED AND
    "USING RESULT DATA POPULATE THE result parameter of the method
    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    ALL FIELDS WITH
    VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky ) )
    RESULT DATA(lt_data).

    result = VALUE #( FOR ls_data IN lt_data ( %tky = ls_data-%tky
                                               %param = ls_data ) ).


  ENDMETHOD.

  METHOD get_instance_features.


    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data)
    FAILED DATA(lt_failed).

    result = VALUE #( FOR ls_data IN lt_data ( %tky = ls_data-%tky
                                               %features-%action-acceptTravel = COND #( WHEN ls_data-OverallStatus = 'A'
                                                                                        THEN if_abap_behv=>fc-o-disabled
                                                                                        ELSE if_abap_behv=>fc-o-enabled )

                                               %features-%action-rejectTravel = COND #( WHEN ls_data-OverallStatus = 'X'
                                                                                        THEN if_abap_behv=>fc-o-disabled
                                                                                        ELSE if_abap_behv=>fc-o-enabled
                                               )
                                               %features-%assoc-_booking = COND #( WHEN ls_data-OverallStatus = 'X'
                                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                                   ELSE if_abap_behv=>fc-o-enabled

                                               )

                                                                                         ) ).
  ENDMETHOD.

  METHOD validateCustomerId.

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA : lt_customer TYPE SORTED TABLE OF zi_nik_travel_m WITH UNIQUE KEY CustomerId.

    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING CustomerId = CustomerId ).


    DELETE lt_customer WHERE CustomerId IS INITIAL.
    IF lt_customer IS NOT INITIAL.
      SELECT
      FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_customer
      WHERE customer_id = @lt_customer-CustomerId
      INTO TABLE @DATA(lt_cust_data).
    ENDIF.


    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-CustomerId IS INITIAL OR NOT line_exists( lt_cust_data[ customer_id = <ls_travel>-CustomerId ] ).
        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-zi_nik_travel_m.

        APPEND VALUE #( %tky = <ls_travel>-%tky
*                  TravelId = <ls_travel>-TravelId "no need as we are using %tky(technical-key)
                        "Use %element-<field> when you want to associate the message with a specific field.
                        %element-CustomerId = if_abap_behv=>mk-on
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Customer with { <ls_travel>-CustomerId } doesnot exist .|
                               )
*                   %msg = NEW /dmo/cm_flight_messages(
*                                            textid                = /dmo/cm_flight_messages=>customer_unkown
*                                           customer_id           = <ls_travel>-CustomerId
*                                severity              = if_abap_behv_message=>severity-error
*                                )
                        ) TO reported-zi_nik_travel_m.

      ENDIF.
    ENDLOOP.







  ENDMETHOD.

  METHOD validateAgencyId.


    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    FIELDS ( AgencyId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA : lt_agencies TYPE SORTED TABLE OF /dmo/agency WITH UNIQUE KEY agency_id.

    lt_agencies = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING agency_id = AgencyId ).

    DELETE lt_agencies WHERE agency_id IS INITIAL.

    IF lt_agencies IS NOT INITIAL.
      SELECT
      FROM /dmo/agency
      FIELDS agency_id
      FOR ALL ENTRIES IN @lt_agencies
      WHERE agency_id = @lt_agencies-agency_id
      INTO TABLE @DATA(lt_actual_agencies).
      IF sy-subrc = 0.
      ENDIF.
    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).
      IF <fs_travel>-AgencyId IS INITIAL OR NOT line_exists( lt_actual_agencies[ agency_id = <fs_travel>-AgencyId ] ).
        APPEND VALUE #( %tky = <fs_travel>-%tky ) TO failed-zi_nik_travel_m.
        APPEND VALUE #( %tky = <fs_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                    textid                = /dmo/cm_flight_messages=>agency_unkown
                                    agency_id             = <fs_travel>-AgencyId
                                    severity              = if_abap_behv_message=>severity-error )
                       %element-agencyid = if_abap_behv=>mk-on
        ) TO reported-zi_nik_travel_m.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD reCalcTotalPrice.

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m BY \_booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travels )
    RESULT DATA(lt_booking_rba).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_booking_m BY \_booksuppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_booking_rba )
    RESULT DATA(lt_booksuppl_rba).


    TYPES : BEGIN OF ty_total,
              price    TYPE /dmo/total_price,
              currCode TYPE /dmo/currency_code,
            END OF ty_total.
    DATA : lt_total TYPE TABLE OF ty_total,
           lv_price TYPE /dmo/total_price,
           lv_total TYPE /dmo/total_price.

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<fs_travel>).
      APPEND VALUE #( price = <fs_travel>-BookingFee
                      currCode = <fs_travel>-CurrencyCode ) TO lt_total.
      LOOP AT lt_booking_rba ASSIGNING FIELD-SYMBOL(<fs_booking_rba>)
                              USING KEY entity
                              WHERE TravelId = <fs_travel>-TravelId
                              AND CurrencyCode IS NOT INITIAL.


        APPEND VALUE #( price = <fs_booking_rba>-FlightPrice
                  currCode = <fs_booking_rba>-CurrencyCode ) TO lt_total.

        LOOP AT lt_booksuppl_rba ASSIGNING FIELD-SYMBOL(<fs_booksuppl_rba>) USING KEY entity
                                 WHERE TravelId = <fs_travel>-TravelId
                                 AND BookingId = <fs_booking_rba>-BookingId
                                 AND CurrencyCode IS NOT INITIAL.


          APPEND VALUE #( price = <fs_booksuppl_rba>-Price
                   currCode = <fs_booksuppl_rba>-CurrencyCode ) TO lt_total.
        ENDLOOP.
      ENDLOOP.
      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<fs_total>).

        IF <fs_total>-currcode = <fs_travel>-CurrencyCode.
          lv_price = <fs_total>-price.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <fs_total>-price
              iv_currency_code_source = <fs_total>-currcode
              iv_currency_code_target = <fs_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
            IMPORTING
              ev_amount               = lv_price
          ).

        ENDIF.
        lv_total += lv_price.
      ENDLOOP.
      <fs_travel>-TotalPrice = lv_total.
      CLEAR : lv_total,lv_price,lt_total.
    ENDLOOP.

    MODIFY ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    UPDATE
    FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travels )
    REPORTED DATA(lt_reported).


  ENDMETHOD.

  METHOD determineTotalPrice.
    MODIFY ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m
    EXECUTE reCalcTotalPrice
    FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
