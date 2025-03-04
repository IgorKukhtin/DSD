-- View: Object_RoleAccessKeyDocument_View

-- DROP VIEW IF EXISTS Object_RoleAccessKeyDocument_View;

CREATE OR REPLACE VIEW Object_RoleAccessKeyDocument_View AS

  WITH tmpProcessAll AS (SELECT Object.Id              AS Id
                              , Object.ObjectCode      AS Code
                              , Object.ValueData       AS Name
                              , ObjectString.ValueData AS EnumName
                              , Object.isErased        AS isErased
                         FROM Object
                              LEFT JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                                                    AND ObjectString.DescId = zc_ObjectString_Enum()
                         WHERE Object.DescId = zc_Object_Process()
                        )
     , tmpAccessKey AS (SELECT tmpProcessAll.*
                             , CASE WHEN Id IN (zc_Enum_Process_AccessKey_CashDnepr()
                                              , zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                              , zc_Enum_Process_AccessKey_CashKiev()
                                              , zc_Enum_Process_AccessKey_CashLviv()
                                              , zc_Enum_Process_AccessKey_CashVinnica()
                                              , zc_Enum_Process_AccessKey_CashKrRog()
                                              , zc_Enum_Process_AccessKey_CashNikolaev()
                                              , zc_Enum_Process_AccessKey_CashKharkov()
                                              , zc_Enum_Process_AccessKey_CashCherkassi()
                                              , zc_Enum_Process_AccessKey_CashDoneck()
                                              , zc_Enum_Process_AccessKey_CashOdessa()
                                              , zc_Enum_Process_AccessKey_CashZaporozhye()

                                              , zc_Enum_Process_AccessKey_CashIrna()
                                               )
                                         THEN TRUE
                                    ELSE NULL
                               END AS isCash
                             , CASE WHEN Id IN (zc_Enum_Process_AccessKey_DocumentBread()
                                              , zc_Enum_Process_AccessKey_DocumentDnepr()
                                              , zc_Enum_Process_AccessKey_DocumentKiev()
                                              , zc_Enum_Process_AccessKey_DocumentLviv()
                                              , zc_Enum_Process_AccessKey_DocumentVinnica()
                                              , zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                              , zc_Enum_Process_AccessKey_DocumentOdessa()
                                              , zc_Enum_Process_AccessKey_DocumentKrRog()
                                              , zc_Enum_Process_AccessKey_DocumentNikolaev()
                                              , zc_Enum_Process_AccessKey_DocumentKharkov()
                                              , zc_Enum_Process_AccessKey_DocumentCherkassi()
                                              , zc_Enum_Process_AccessKey_DocumentIrna()
                                               )
                                         THEN TRUE
                                    ELSE NULL
                               END AS isMovement
                             , CASE WHEN Id IN (zc_Enum_Process_AccessKey_TrasportDnepr()
                                              , zc_Enum_Process_AccessKey_TrasportKiev()
                                              , zc_Enum_Process_AccessKey_TrasportLviv()
                                              , zc_Enum_Process_AccessKey_TrasportVinnica()
                                              , zc_Enum_Process_AccessKey_TrasportKrRog()
                                              , zc_Enum_Process_AccessKey_TrasportNikolaev()
                                              , zc_Enum_Process_AccessKey_TrasportKharkov()
                                              , zc_Enum_Process_AccessKey_TrasportCherkassi()
                                              , zc_Enum_Process_AccessKey_TrasportDoneck()
                                              , zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                              , zc_Enum_Process_AccessKey_TrasportOdessa()
                                              , zc_Enum_Process_AccessKey_TrasportIrna()
                                               )
                                         THEN TRUE
                                    ELSE NULL
                               END AS isTransport
                        FROM tmpProcessAll
                       )
     , tmpProcessDoc AS (SELECT tmpProcessAll.*
                              , CASE WHEN Id IN (zc_Enum_Process_InsertUpdate_Movement_Cash()
                                               , zc_Enum_Process_Get_Movement_Cash()
                                                )
                                          THEN TRUE
                                     ELSE NULL
                                END AS isCash
                              , CASE WHEN Id IN (zc_Enum_Process_InsertUpdate_Movement_Income()
                                               , zc_Enum_Process_InsertUpdate_Movement_ReturnOut()
                                               , zc_Enum_Process_InsertUpdate_Movement_Sale()
                                               , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                               , zc_Enum_Process_InsertUpdate_Movement_ReturnIn()
                                               , zc_Enum_Process_InsertUpdate_Movement_ReturnIn_Partner()
                                               , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                               , zc_Enum_Process_InsertUpdate_Movement_SendOnPrice_Branch()
                                               , zc_Enum_Process_InsertUpdate_Movement_Send()
                                               , zc_Enum_Process_InsertUpdate_Movement_Loss()
                                               , zc_Enum_Process_InsertUpdate_Movement_Inventory()
                                               , zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()

                                               , zc_Enum_Process_InsertUpdate_Movement_Tax()
                                               , zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()
                                               , zc_Enum_Process_InsertUpdate_Movement_PriceCorrective()
                                               , zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn()
                                               , zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut()

                                               , zc_Enum_Process_InsertUpdate_Movement_OrderExternal()
                                               , zc_Enum_Process_InsertUpdate_Movement_OrderInternal()
                                                )
                                          THEN TRUE
                                     ELSE NULL
                                END AS isMovement
                              , CASE WHEN Id IN (zc_Enum_Process_InsertUpdate_Movement_Transport()
                                               , zc_Enum_Process_Get_Movement_Transport()
                                               , zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                               , zc_Enum_Process_Get_Movement_TransportService()
                                               , zc_Enum_Process_InsertUpdate_Movement_IncomeFuel()
                                               , zc_Enum_Process_InsertUpdate_Movement_TransportIncome()
                                               , zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()
                                               , zc_Enum_Process_InsertUpdate_Movement_PersonalAccount()
                                                )
                                          THEN TRUE
                                     ELSE NULL
                                END AS isTransport
                         FROM tmpProcessAll
                        )

   SELECT tmpAccessKey.Id        AS AccessKeyId
        , tmpAccessKey.Name      AS AccessKeyName
        , tmpAccessKey.EnumName  AS AccessKeyEnumName
        , tmpProcessDoc.Id       AS ProcessId
        , tmpProcessDoc.Name     AS ProcessName
        , tmpProcessDoc.EnumName AS ProcessEnumName
   FROM tmpAccessKey
        INNER JOIN tmpProcessDoc ON tmpProcessDoc.isCash = tmpAccessKey.isCash
                                 OR tmpProcessDoc.isMovement = tmpAccessKey.isMovement
                                 OR tmpProcessDoc.isTransport = tmpAccessKey.isTransport
   -- WHERE tmpAccessKey.Id NOT IN (zc_Enum_Process_AccessKey_DocumentAll())
  ;

ALTER TABLE Object_RoleAccessKeyDocument_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 20.10.14                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_RoleAccessKeyDocument_View
