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
                                              , zc_Enum_Process_AccessKey_CashKiev()
                                              , zc_Enum_Process_AccessKey_CashZaporozhye()
                                               )
                                         THEN TRUE
                                    ELSE NULL
                               END AS isCash
                             , CASE WHEN Id IN (zc_Enum_Process_AccessKey_DocumentDnepr()
                                              , zc_Enum_Process_AccessKey_DocumentKiev()
                                              , zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                              , zc_Enum_Process_AccessKey_DocumentBread()
                                               )
                                         THEN TRUE
                                    ELSE NULL
                               END AS isMovement
                             , CASE WHEN Id IN (zc_Enum_Process_AccessKey_TrasportDnepr()
                                              , zc_Enum_Process_AccessKey_TrasportKiev()
                                              , zc_Enum_Process_AccessKey_TrasportKrRog()
                                              , zc_Enum_Process_AccessKey_TrasportNikolaev()
                                              , zc_Enum_Process_AccessKey_TrasportKharkov()
                                              , zc_Enum_Process_AccessKey_TrasportCherkassi()
                                              , zc_Enum_Process_AccessKey_TrasportDoneck()
                                              , zc_Enum_Process_AccessKey_TrasportZaporozhye()
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
                              , CASE WHEN Id IN (zc_Enum_Process_InsertUpdate_Movement_OrderExternal())
                                          THEN TRUE
                                     ELSE NULL
                                END AS isMovement
                              , CASE WHEN Id IN (zc_Enum_Process_InsertUpdate_Movement_TransportService()
                                               , zc_Enum_Process_Get_Movement_TransportService()
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
