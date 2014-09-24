-- View: Object_Role_MovementDesc_View

-- DROP VIEW IF EXISTS Object_Role_MovementDesc_View;

CREATE OR REPLACE VIEW Object_Role_MovementDesc_View AS

   SELECT RoleId
        , Object_Role.ObjectCode AS RoleCode
        , Object_Role.ValueData AS RoleName
        , MovementDesc.Id AS MovementDescId
        , MovementDesc.ItemName AS MovementDescName
   FROM MovementDesc
        LEFT JOIN (SELECT ProcessId, Object_Role_Process_View.RoleId FROM Object_Role_Process_View INNER JOIN PeriodClose ON PeriodClose.RoleId = Object_Role_Process_View.RoleId GROUP BY ProcessId, Object_Role_Process_View.RoleId, RoleCode, RoleName
                  ) AS Object_Role_Process_View ON ProcessId = CASE WHEN MovementDesc.Id = zc_Movement_Sale()     THEN zc_Enum_Process_Complete_Sale()
                                                                    WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN zc_Enum_Process_Complete_Sale()
                                                                    WHEN MovementDesc.Id = zc_Movement_PriceCorrective() THEN zc_Enum_Process_Complete_Sale()

                                                                    WHEN MovementDesc.Id = zc_Movement_Tax()           THEN zc_Enum_Process_Complete_PriceCorrective()
                                                                    WHEN MovementDesc.Id = zc_Movement_TaxCorrective() THEN zc_Enum_Process_Complete_PriceCorrective()

                                                                    WHEN MovementDesc.Id = zc_Movement_TransferDebtIn()  THEN zc_Enum_Process_Complete_TransferDebtIn()
                                                                    WHEN MovementDesc.Id = zc_Movement_TransferDebtOut() THEN zc_Enum_Process_Complete_TransferDebtOut()

                                                                    WHEN MovementDesc.Id = zc_Movement_Service() THEN zc_Enum_Process_Complete_Service()
                                                                    WHEN MovementDesc.Id = zc_Movement_PersonalService() THEN zc_Enum_Process_Complete_PersonalService()
                                                                    WHEN MovementDesc.Id = zc_Movement_SendDebt() THEN zc_Enum_Process_Complete_SendDebt()
                                                               END
        LEFT JOIN Object AS Object_Role    ON Object_Role.Id = Object_Role_Process_View.RoleId
   ;
ALTER TABLE Object_Role_MovementDesc_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 23.09.14                                        *
*/

-- òåñò
-- SELECT * FROM Object_Role_MovementDesc_View WHERE RoleId > 0 ORDER BY MovementDescId

