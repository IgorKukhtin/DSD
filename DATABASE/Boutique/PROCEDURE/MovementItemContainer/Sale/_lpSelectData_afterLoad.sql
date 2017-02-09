-- UPDATE _testMI_afterLoad SET OperDate = DATE_TRUNC ('DAY', OperDate) WHERE OperDate <> DATE_TRUNC ('DAY', OperDate)
-- SELECT * FROM _testMI_afterLoad WHERE MovementItemId = 2439838
-- update _testMI_afterLoad set StatusId = zc_Enum_Status_Complete() WHERE MovementId in (327959, 328502) and SessionId = 13 and StatusId = zc_Enum_Status_UnComplete()

   WITH tmpDate AS (SELECT '01.06.2014' :: TDateTime AS StartDate, '30.06.2014' :: TDateTime AS EndDate)
       SELECT MAX (SessionId) AS SessionId
            , MAX (SessionId_min) AS SessionId_min
            , tmpAll.MovementId
            , tmpAll.InvNumber
            , tmpAll.OperDate
            , tmpAll.OperDatePartner
            , tmpAll.PaidKindId
            , tmpAll.MovementItemId
            , tmpAll.GoodsId
            , SUM (tmpAll.AmountPartner) AS AmountPartner
            , SUM (tmpAll.AmountPartnerNew) AS AmountPartnerNew
            , SUM (tmpAll.Amount) AS Amount
            , SUM (tmpAll.AmountNew) AS AmountNew
            , tmpAll.Price
            , MIN (tmpAll.OperDate) AS minOperDate, MAX (tmpAll.OperDate) AS maxOperDate
       FROM (
             SELECT tmpSession.Id AS SessionId
                  , tmpSession.minId AS SessionId_min
                  , MovementId
                  , InvNumber
                  , DATE_TRUNC ('DAY', OperDate) AS OperDate
                  , DATE_TRUNC ('DAY', OperDatePartner) AS OperDatePartner
                  , PaidKindId
                  , MovementItemId
                  , GoodsId
                  , AmountPartner
                  , 0 AS AmountPartnerNew
                  , Amount
                  , 0 AS AmountNew
                  , Price
             FROM (SELECT MAX (SessionId) AS Id, MIN (SessionId) AS minId FROM _testMI_afterLoad WHERE OperDatePartner /*OperDate*/ BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)) as tmpSession
                  INNER JOIN _testMI_afterLoad ON _testMI_afterLoad.SessionId = tmpSession.Id
             WHERE _testMI_afterLoad.OperDatePartner BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)
               -- AND _testMI_afterLoad.OperDate BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)
               AND _testMI_afterLoad.DescId = zc_Movement_Sale()
               AND _testMI_afterLoad.StatusId = zc_Enum_Status_Complete()
               AND _testMI_afterLoad.isErased = FALSE
               AND _testMI_afterLoad.PaidKindId = zc_Enum_PaidKind_FirstForm()
               AND _testMI_afterLoad.FromId = 8459 -- Склад Реализации
--               AND _testMI_afterLoad.MovementItemId = 2439838
            UNION ALL
             SELECT 0 AS SessionId
                  , 0 AS SessionId_min
                  , Movement.Id AS MovementId
                  , Movement.InvNumber
                  , DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate
                  , DATE_TRUNC ('DAY', CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END) AS OperDatePartner
                  , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
                  , MovementItem.Id AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , 0 AS AmountPartner
                  , COALESCE (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) AS AmountPartnerNew
                  , 0 AS Amount
                  , MovementItem.Amount as AmountNew
                  , COALESCE (MIFloat_Price.ValueData, 0) AS Price
             FROM Movement
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                  LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                         ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.isErased = FALSE
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()    

             WHERE Movement.DescId = zc_Movement_Sale() -- IN (zc_Movement_Tax(), zc_Movement_Sale()) zc_Movement_ReturnIn())
               AND Movement.StatusId = zc_Enum_Status_Complete()
               -- AND Movement.OperDate BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)
               -- AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)
               AND MovementDate_OperDatePartner.ValueData BETWEEN (SELECT StartDate FROM tmpDate) AND (SELECT EndDate FROM tmpDate)
               AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
               AND MovementLinkObject_From.ObjectId = 8459 -- Склад Реализации
--               AND MovementItem.Id = 2439838

            ) AS tmpAll
       GROUP BY tmpAll.MovementId
              , tmpAll.InvNumber
              , tmpAll.OperDate
              , tmpAll.OperDatePartner
              , tmpAll.PaidKindId
              , tmpAll.MovementItemId
              , tmpAll.GoodsId
              , tmpAll.Price
       HAVING SUM (tmpAll.AmountPartner) <> SUM (tmpAll.AmountPartnerNew)
--           OR MAX (tmpAll.OperDate) <> MIN (tmpAll.OperDate)
       ORDER BY tmpAll.MovementId, tmpAll.InvNumber, tmpAll.GoodsId

/*
-- select lpInsert_MovementItemProtocol (a.MovementItemId , 9457 , false) from (select MovementItemId from MovementItemProtocol  where MovementItemProtocol.UserId =  81238 and MovementItemProtocol.OperDate between '01.06.2014' and '08.07.2014' group by MovementItemId) as a
with aaa as
(select MovementItemProtocol.Id, MovementItemProtocol2.Id as Id2
      , MovementItemProtocol.MovementItemId
      , MovementItemProtocol.ProtocolData as oldProtocolData, MovementItemProtocol2.ProtocolData as newProtocolData
from (select max (Id) as id from MovementItemProtocol  where MovementItemProtocol.UserId =  81238 and MovementItemProtocol.OperDate between '01.06.2014' and '08.07.2014' group by MovementItemId
      ) as a
     left join MovementItemProtocol  on MovementItemProtocol .Id = a.Id
     left join MovementItemProtocol as MovementItemProtocol2  on MovementItemProtocol2.MovementItemId = MovementItemProtocol.MovementItemId
                                   and MovementItemProtocol2.UserId =  9457
                                   and MovementItemProtocol2.OperDate between '08.07.2014' and '10.07.2014'
 where MovementItemProtocol.ProtocolData <> MovementItemProtocol2.ProtocolData
)
-- select * from aaa

select 1 as x, aaa.MovementItemId, Movement.OperDate, Movement.InvNumber,  Movement.DescId, oldProtocolData
from aaa
     left join MovementItemProtocol  on MovementItemProtocol.Id = aaa.Id
     left join MovementItem  on MovementItem.Id = aaa.MovementItemId
     left join Movement on Movement.Id = MovementItem.MovementId
union all
select 2  as x, aaa.MovementItemId, Movement.OperDate, Movement.InvNumber,  Movement.DescId, newProtocolData
from aaa
     left join MovementItemProtocol  on MovementItemProtocol.Id = aaa.Id2
     left join MovementItem  on MovementItem.Id = aaa.MovementItemId
     left join Movement on Movement.Id = MovementItem.MovementId

  order by 4, 2, 1
*/