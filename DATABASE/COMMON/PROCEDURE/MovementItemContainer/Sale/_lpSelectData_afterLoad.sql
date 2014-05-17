-- UPDATE _testMI_afterLoad SET OperDate = DATE_TRUNC ('DAY', OperDate) WHERE OperDate <> DATE_TRUNC ('DAY', OperDate)
-- SELECT * FROM _testMI_afterLoad WHERE MovementItemId = 2439838

  SELECT tmpAll.MovementId
       , tmpAll.InvNumber
       , tmpAll.MovementItemId
       , tmpAll.GoodsId
       , SUM (tmpAll.AmountPartner) AS AmountPartner
       , SUM (tmpAll.AmountPartnerNew) AS AmountPartnerNew
       , SUM (tmpAll.Amount) AS Amount
       , SUM (tmpAll.AmountNew) AS AmountNew
       , tmpAll.Price
       , MIN (tmpAll.OperDate) AS minOperDate, MAX (tmpAll.OperDate) AS maxOperDate
  FROM (
        SELECT MovementId
             , InvNumber
             , DATE_TRUNC ('DAY', OperDate) AS OperDate
             , MovementItemId
             , GoodsId
             , AmountPartner
             , 0 AS AmountPartnerNew
             , Amount
             , 0 AS AmountNew
             , Price
        FROM (SELECT MAX (SessionId) AS Id FROM _testMI_afterLoad) as tmpSession
             INNER JOIN _testMI_afterLoad ON _testMI_afterLoad.SessionId = tmpSession.Id
        WHERE _testMI_afterLoad.OperDate BETWEEN '01.04.2014' AND '09.04.2014'
          AND _testMI_afterLoad.DescId = zc_Movement_Sale()
          AND _testMI_afterLoad.StatusId = zc_Enum_Status_Complete()
          AND _testMI_afterLoad.isErased = FALSE
          AND _testMI_afterLoad.FromId = 8459 -- Склад Реализации
--          AND _testMI_afterLoad.MovementItemId = 2439838
       UNION ALL
        SELECT Movement.Id AS MovementId
             , Movement.InvNumber
             , DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate
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
          AND Movement.OperDate BETWEEN '01.04.2014' AND '09.04.2014'
          AND MovementLinkObject_From.ObjectId = 8459 -- Склад Реализации
--          AND MovementItem.Id = 2439838

       ) AS tmpAll
  GROUP BY tmpAll.MovementId
         , tmpAll.InvNumber
         , tmpAll.MovementItemId
         , tmpAll.GoodsId
         , tmpAll.Price
  HAVING SUM (tmpAll.AmountPartner) <> SUM (tmpAll.AmountPartnerNew)
--      OR MAX (tmpAll.OperDate) <> MIN (tmpAll.OperDate)
  ORDER BY tmpAll.MovementId, tmpAll.InvNumber, tmpAll.GoodsId
