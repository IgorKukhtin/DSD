 -- Function: gpSelect_MovementItem_OrderFinance_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinance_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinance_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , InvNumber  TVarChar
             , InvNumber_Invoice TVarChar
             , GoodsName TVarChar
             , Comment TVarChar
             , Comment_SB         TVarChar

               -- Первичный план на неделю
             , Amount     TFloat
               -- Платежный план на неделю
             , AmountPlan_next      TFloat
               -- Дата Платежный план на неделю
             , OperDate_next      TDateTime
               -- Платежный план на неделю
             , AmountPlan_1         TFloat
             , AmountPlan_2         TFloat
             , AmountPlan_3         TFloat
             , AmountPlan_4         TFloat
             , AmountPlan_5         TFloat
               -- Платим да/нет
             , isAmountPlan_1       Boolean
             , isAmountPlan_2       Boolean
             , isAmountPlan_3       Boolean
             , isAmountPlan_4       Boolean
             , isAmountPlan_5       Boolean

               --
             , MovementItemId_OrderIncome Integer

             , isSign Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH
     tmpMI_Child AS (SELECT MovementItem.*
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           AND MovementItem.isErased   = tmpIsErased.isErased
                           ORDER BY MovementItem.Id

                    )

       -- Результат
       SELECT
             MovementItem.Id                         AS Id
           , MovementItem.ParentId
           , MIString_InvNumber.ValueData ::TVarChar AS InvNumber
           , MIString_InvNumber_Invoice.ValueData ::TVarChar AS InvNumber_Invoice
           , MIString_GoodsName.ValueData ::TVarChar AS GoodsName
           , MIString_Comment.ValueData   ::TVarChar AS Comment
           , MIString_Comment_SB.ValueData           AS Comment_SB

             -- Первичный план на неделю
           , MovementItem.Amount          :: TFloat  AS Amount
             -- Платежный план на неделю
           , MIFloat_AmountPlan_next.ValueData       AS AmountPlan_next
           , MIDate_Amount_next.ValueData            AS OperDate_next
             -- Согласовано к оплате
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END :: TFloat AS AmountPlan_1
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 2 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END :: TFloat AS AmountPlan_2
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 3 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END :: TFloat AS AmountPlan_3
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 4 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END :: TFloat AS AmountPlan_4
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 5 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END :: TFloat AS AmountPlan_5

             -- Платим да/нет
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_1.ValueData, TRUE) ELSE FALSE END ::Boolean AS isAmountPlan_1
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_2.ValueData, TRUE) ELSE FALSE END ::Boolean AS isAmountPlan_2
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_3.ValueData, TRUE) ELSE FALSE END ::Boolean AS isAmountPlan_3
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_4.ValueData, TRUE) ELSE FALSE END ::Boolean AS isAmountPlan_4
           , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIBoolean_AmountPlan_5.ValueData, TRUE) ELSE FALSE END ::Boolean AS isAmountPlan_5

           , 0 ::Integer AS MovementItemId_OrderIncome

           , COALESCE (MIBoolean_Sign.ValueData, FALSE) ::Boolean AS isSign
           , MovementItem.isErased                      ::Boolean AS isErased

       FROM tmpMI_Child AS MovementItem
            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

            LEFT JOIN MovementItemString AS MIString_InvNumber
                                         ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                        AND MIString_InvNumber.DescId = zc_MIString_InvNumber()

            LEFT JOIN MovementItemString AS MIString_InvNumber_Invoice
                                         ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                        AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemString AS MIString_Comment_SB
                                         ON MIString_Comment_SB.MovementItemId = MovementItem.Id
                                        AND MIString_Comment_SB.DescId = zc_MIString_Comment_SB()

            -- Платежный план на неделю
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                        ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
            -- Дата Платежный план
            LEFT JOIN MovementItemDate AS MIDate_Amount_next
                                       ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                      AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()

            -- Согласовано СБ
            LEFT JOIN MovementItemBoolean AS MIBoolean_Sign
                                          ON MIBoolean_Sign.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Sign.DescId = zc_MIBoolean_Sign()

            -- Платим (да/нет)
            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan_1
                                          ON MIBoolean_AmountPlan_1.MovementItemId = MovementItem.Id
                                         AND MIBoolean_AmountPlan_1.DescId = zc_MIBoolean_AmountPlan_1()
            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan_2
                                          ON MIBoolean_AmountPlan_2.MovementItemId = MovementItem.Id
                                         AND MIBoolean_AmountPlan_2.DescId = zc_MIBoolean_AmountPlan_2()
            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan_3
                                          ON MIBoolean_AmountPlan_3.MovementItemId = MovementItem.Id
                                         AND MIBoolean_AmountPlan_3.DescId = zc_MIBoolean_AmountPlan_3()
            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan_4
                                          ON MIBoolean_AmountPlan_4.MovementItemId = MovementItem.Id
                                         AND MIBoolean_AmountPlan_4.DescId = zc_MIBoolean_AmountPlan_4()
            LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan_5
                                          ON MIBoolean_AmountPlan_5.MovementItemId = MovementItem.Id
                                         AND MIBoolean_AmountPlan_5.DescId = zc_MIBoolean_AmountPlan_5()

    /*UNION ALL
       -- Пустая строчка для удобства
       SELECT
             0                   AS Id
           , MovementItem.Id     AS ParentId
           , ''    ::TVarChar    AS InvNumber
           , ''    ::TVarChar    AS InvNumber_Invoice
           , ''    ::TVarChar    AS GoodsName
           , ''    ::TVarChar    AS Comment
           , ''    ::TVarChar    AS Comment_SB
           , 0     ::TFloat      AS Amount

           , 0     ::Integer     AS MovementItemId_OrderIncome

           , FALSE ::Boolean     AS isSign
           , MovementItem.isErased

       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND 1=0*/
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.01.26         *
 14.01.26         *
*/

-- тест
--
-- SELECT * FROM gpSelect_MovementItem_OrderFinance_Child (inMovementId:= 20081622, inIsErased:= FALSE, inSession:= '9818')
