# SAP ABAP RAP – Managed Travel Business Object

A hands-on implementation of the **ABAP RESTful Application Programming Model (RAP)** built around a Travel Management scenario, extending SAP's standard `/DMO/` flight reference data model with a fully custom managed Business Object, custom actions, validations, determinations, audit logging, and a role-restricted approval app.

## Overview

This project implements a **Travel** root entity composed of **Booking** and **Booking Supplement** child entities, backed by custom Z-tables and enriched with SAP's reusable master data (Agency, Customer, Connection, Airport). It goes beyond a standard CRUD BO by adding real business logic: approval workflows, deep-copy actions, cross-currency pricing, custom numbering, and field-level audit trails.

Two consuming apps are exposed from the same Business Object:
- **Travel App** – full create/update/delete + copy/accept/reject actions
- **Travel Approval App** – a restricted view exposing only update, accept, and reject, for use by approvers

## Business Object Structure

```
Travel (root)
 └── Booking (composition)
      └── Booking Supplement (composition)
```

| Entity | Interface View | Projection View(s) |
|---|---|---|
| Travel | `ZI_NIK_TRAVEL_M` | `ZC_NIK_TRAVEL_M`, `ZC_NIK_TRAVEL_APP_M` |
| Booking | `ZI_NIK_BOOKING_M` | `ZC_NIK_BOOKING_M`, `ZC_NIK_BKNG_APP_M` |
| Booking Supplement | `ZI_NIK_BOOKSUPPL_M` | `ZC_NIK_BOOKSUPPL_M` |

## Key Features

- **Custom actions** – `acceptTravel`, `rejectTravel`, and a factory action `copyTravel` that deep-copies a Travel along with all its Bookings and Booking Supplements in a single EML call.
- **Validations** – `validateCustomerId` and `validateAgencyId` check incoming data against SAP's reference Customer and Agency master data before save.
- **Determinations** – `determineTotalPrice` recalculates the travel's total price on create and on relevant field changes, including **cross-currency conversion** via AMDP.
- **Feature control** – actions and associations (e.g., accept/reject, create booking) are dynamically enabled or disabled based on the current `OverallStatus` of the travel.
- **Custom early numbering** – self-implemented number assignment for both the root entity (via a SAP number range object) and child Bookings (max-ID + increment logic, safe across multiple new instances in one transaction).
- **Audit logging** – a custom save sequence (`cl_abap_behavior_saver`) writes field-level change history (old value, new value, operation, user, timestamp) to a dedicated log table for every create, update, and delete.
- **Role-based approval app** – a second projection/behavior/service layer reuses the same core BO but exposes only the operations relevant to an approver, demonstrating separation of business logic from UI-facing projections.
- **EML practice classes** – standalone classes demonstrating `READ ENTITY` and `MODIFY ENTITY` usage outside the RAP transactional context.

## Services Exposed

| Service Definition | Service Binding(s) | Purpose |
|---|---|---|
| `ZSRVD_NIK_TRAVEL_M` | OData V2 UI, OData V4 UI | Full Travel app (CRUD + actions) |
| `ZSRVD_NIK_TRAVEL_APPR_M` | OData V2 UI | Travel Approval app (update + accept/reject only) |

## Repository Structure

```
├── CDS/          Interface and projection view entities
├── Behavior/      Behavior definitions and behavior pool implementations
├── Service/       Service definitions and service bindings
├── classes/       Standalone EML practice/demo classes
├── metadata/      UI/metadata extensions
└── tables/        Custom database tables and reused DMO reference tables
```

## Tech Stack

SAP ABAP RESTful Application Programming Model (RAP) · ABAP CDS Views · Behavior Definitions & Implementations · OData V2/V4 · AMDP (currency conversion) · Entity Manipulation Language (EML)

## Notes

This is a learning/portfolio project built on top of SAP's standard `/DMO/` flight reference scenario, developed to explore managed RAP concepts in depth: custom numbering, determinations, validations, feature control, factory actions, custom save logic, and multi-app exposure of a single Business Object.
