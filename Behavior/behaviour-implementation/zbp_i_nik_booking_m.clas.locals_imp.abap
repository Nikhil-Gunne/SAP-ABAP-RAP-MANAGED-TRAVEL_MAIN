CLASS lhc_zi_nik_booking_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
      IMPORTING entities FOR CREATE zi_nik_booking_m\_Booksuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_nik_booking_m RESULT result.
    METHODS determinetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_nik_booking_m~determinetotalprice.

ENDCLASS.

CLASS lhc_zi_nik_booking_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksuppl.

    DATA(lv_max_suppl_id) = CONV  /dmo/booking_supplement_id( '0' ).

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_booking_m BY \_booksuppl
     FROM CORRESPONDING #( entities )
     LINK DATA(lt_link_data)
     FAILED DATA(lt_failed).


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_grp_entity>)
                     GROUP BY <fs_grp_entity>-%tky.

      "loop over the entities from the persistent table to find max supplement id.
      lv_max_suppl_id = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                  FOR ls_link_data IN lt_link_data USING KEY entity
                                  WHERE ( source-%tky = <fs_grp_entity>-%tky )
                                  NEXT lv_max = COND #( WHEN lv_max < ls_link_data-target-BookingSupplementId
                                                        THEN ls_link_data-target-BookingSupplementId
                                                        ELSE lv_max )
                                  ).
      "loop over the entites that are in transactional buffer or bookingsupplements that already have ids
      "to find max id useful in scenarios like draft.
      lv_max_suppl_id = REDUCE #( INIT lv_max = lv_max_suppl_id
                                  FOR ls_entities IN entities USING KEY entity
                                  WHERE ( %tky = <fs_grp_entity>-%tky )
                                  FOR ls_target IN ls_entities-%target
                                  NEXT lv_max = COND #( WHEN lv_max < ls_target-BookingSupplementId
                                                        THEN ls_target-BookingSupplementId
                                                        ELSE lv_max )
                                  ).
      "Process all create requests belonging to the current Booking
      "(%tky uniquely identifies the parent Booking in this CBA request).
      "loop at entities recieved as params with the keys
      " for bookingsupplm %tky = (travelId,BookingId).
      "can be written as separately as well.
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>)
                       USING KEY entity
                       WHERE %tky = <fs_grp_entity>-%tky.

        LOOP AT <fs_entities>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).

          APPEND CORRESPONDING #( <fs_target> ) TO mapped-zi_nik_booksuppl_m ASSIGNING FIELD-SYMBOL(<fs_mapped>).
          IF <fs_target>-BookingSupplementId IS INITIAL.
            lv_max_suppl_id += 1.
            <fs_mapped>-BookingSupplementId = lv_max_suppl_id.

          ENDIF.

        ENDLOOP.
      ENDLOOP.



    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_nik_travel_m IN LOCAL MODE
    ENTITY zi_nik_travel_m BY \_booking
    FIELDS ( TravelId BookingId BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).

    result = VALUE #( FOR ls_data IN lt_data ( %tky = ls_data-%tky
                                               %features-%assoc-_booksuppl = COND #( WHEN ls_data-BookingStatus = 'X'
                                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                                     ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD determineTotalPrice.
    "Rule of thumb
*Calling an action on the same entity whose keys you already have → use keys directly.
*Calling an action on a parent entity from child or grandchild keys → create a hashed/sorted table and remove duplicates before calling the action.
*
*
*Travel changed → use keys.
*Booking changed → map to unique TravelIds, discard duplicates, then recalculate Travel once.
*Booking Supplement changed → map to unique TravelIds, discard duplicates, then recalculate Travel once.
    DATA: it_travel TYPE STANDARD TABLE OF zi_nik_travel_m  WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel =  CORRESPONDING #(  keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).
    MODIFY ENTITIES OF zi_nik_travel_m  IN LOCAL MODE
     ENTITY zi_nik_travel_m
     EXECUTE reCalcTotalPrice
     FROM CORRESPONDING #( it_travel ).
*  MODIFY ENTITIES OF zi_nik_travel_m in LOCAL mode
*  ENTITY zi_nik_travel_m
*  EXECUTE reCalcTotalPrice
*  FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

