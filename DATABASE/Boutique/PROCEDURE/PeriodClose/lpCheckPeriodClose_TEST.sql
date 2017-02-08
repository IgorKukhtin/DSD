         WITH tmpDesc AS (SELECT tmp.DescId, tmp.MovementDescId FROM lpSelect_PeriodClose_Desc (inUserId:= 131160 ) AS tmp
                         )
            , tmpTable AS (SELECT tmp.*
                                , CASE WHEN tmp.Date1 > tmp.Date2 THEN tmp.Date1 ELSE tmp.Date2 END AS CloseDate_calc
                                , COALESCE (tmpDesc.MovementDescId, 0)      AS MovementDescId
                                , COALESCE (tmpDesc_excl.MovementDescId, 0) AS MovementDescId_excl
                           FROM (SELECT PeriodClose.*
                                        -- так для "Период закрыт до"
                                      , CASE WHEN PeriodClose.Period =  INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END AS Date1
                                        -- так для "Авто закрытие периода, кол-во дн."
                                      , CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - PeriodClose.Period :: INTERVAL ELSE zc_DateStart() END AS Date2
                                 FROM PeriodClose
                                ) AS tmp
                                LEFT JOIN tmpDesc ON tmpDesc.DescId = tmp.DescId
                                LEFT JOIN tmpDesc AS tmpDesc_excl ON tmpDesc_excl.DescId = tmp.DescId_excl
                          )
            , tmpData AS (SELECT tmpTable.*
                               , COALESCE (ObjectLink_UserRole_User.ChildObjectId, 0) AS UserId_calc
                          FROM tmpTable
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_Role
                                                    ON ObjectLink_UserRole_Role.ChildObjectId = tmpTable.RoleId
                                                   AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_User
                                                    ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                                   AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                          )
         -- Результат
         , _tmpPeriodClose AS (
            SELECT tmpData.Id             AS PeriodCloseId
                 , tmpData.Code
                 , tmpData.Name
                 , tmpData.CloseDate_calc AS CloseDate
                 , tmpData.UserId_calc    AS UserId
                 , tmpData.UserId_excl
                 , tmpData.MovementDescId
                 , tmpData.MovementDescId_excl
                 , COALESCE (tmpData.BranchId, 0)   AS BranchId
                 , COALESCE (tmpData.PaidKindId, 0) AS PaidKindId
                 , tmpData.CloseDate_excl
            FROM tmpData)

     SELECT *
     FROM _tmpPeriodClose
          LEFT JOIN (WITH tmpDesc AS (SELECT zc_MovementLinkObject_PaidKind() AS DescId UNION SELECT zc_MovementLinkObject_PaidKindFrom() WHERE zc_Movement_Sale() NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) UNION SELECT zc_MovementLinkObject_PaidKindTo() WHERE zc_Movement_Sale() NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn()))
                        , tmp1 AS (SELECT DISTINCT MovementLinkObject.ObjectId AS PaidKindId FROM MovementLinkObject JOIN tmpDesc ON tmpDesc.DescId = MovementLinkObject.DescId WHERE MovementLinkObject.MovementId = 3529807)
                        , tmp2 AS (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                                   FROM MovementItem
                                        JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                   WHERE MovementItem.MovementId = 3529807 
                                     AND MovementItem.isErased = FALSE)
                        , tmp3 AS (SELECT zc_Enum_PaidKind_FirstForm()  AS PaidKindId WHERE zc_Movement_Sale() = zc_Movement_BankAccount()  AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2)
                                  UNION ALL
                                   SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE zc_Movement_Sale() <> zc_Movement_BankAccount() AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2))
                     -- подзапрос
                     SELECT tmp1.PaidKindId FROM tmp1 UNION SELECT tmp2.PaidKindId FROM tmp2 UNION SELECT tmp3.PaidKindId FROM tmp3
                    ) AS tmp ON tmp.PaidKindId = _tmpPeriodClose.PaidKindId
     WHERE _tmpPeriodClose.MovementDescId = 0 AND _tmpPeriodClose.UserId = 0 AND _tmpPeriodClose.MovementDescId_excl <> zc_Movement_Sale()
       AND (_tmpPeriodClose.BranchId   = 0)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp.PaidKindId > 0);
