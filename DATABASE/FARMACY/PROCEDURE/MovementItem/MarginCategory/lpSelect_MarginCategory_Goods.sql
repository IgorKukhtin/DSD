-- Function: lpSelect_MarginCategory_Goods()

DROP FUNCTION IF EXISTS lpSelect_MarginCategory_Goods (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_MarginCategory_Goods(
    IN inUnitId              Integer,
    IN inGoodsId             Integer,
    IN inOperDate            TDateTime,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber Integer, OperDate TDateTime
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountDiff TFloat, MarginPercent TFloat, MarginPercentNew TFloat
             , Price TFloat
             , isChecked Boolean
             ) AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;

  DECLARE vbUnitId       Integer;
  DECLARE vbPeriodCount  Integer;
  DECLARE vbDayCount     TFloat;
  DECLARE vbStartSale    TDateTime;
  DECLARE vbEndSale      TDateTime;
BEGIN

    RETURN QUERY
    WITH 
    
    -- ищем документы "Категории наценки (САУЦ)"
    tmpMarginCategory AS (SELECT Movement_MarginCategory.Id            AS Id
                               , Movement_MarginCategory.InvNumber     AS InvNumber
                               , Movement_MarginCategory.OperDate      AS OperDate
                               , MovementDate_OperDateStart.ValueData  AS OperDateStart
                               , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
                          FROM Movement AS Movement_MarginCategory 
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement_MarginCategory.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            AND MovementLinkObject_Unit.ObjectId = inUnitId
                                                                              
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement_MarginCategory.Id
                                                      AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData <= inOperDate--CURRENT_DATE
                   
                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement_MarginCategory.Id
                                                      AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd() 
                                                      AND MovementDate_OperDateEnd.ValueData >= inOperDate
                                                              
                          WHERE Movement_MarginCategory.DescId = zc_Movement_MarginCategory()
                          )
                          
   -- вытягиваем строки чайлд, там категория наценки и %, чтоб по ним определить для мастера % наценки                       
  , tmpMI_Child AS (SELECT Movement.Id                       AS MovementId
                         , MovementItem.Id	             AS MI_Id
                         , MovementItem.ObjectId             AS MarginCategoryItemId
                         , MovementItem.Amount               AS Amount
                         , ObjectFloat_MinPrice.ValueData    AS MinPrice
                         , MIFloat_Amount.ValueData          AS AmountDiff
                         , MovementItem.Amount + COALESCE (MIFloat_Amount.ValueData, 0)  ::TFloat AS PercentNew
                         , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY Movement.Id, ObjectFloat_MinPrice.ValueData) as ORD
                    FROM tmpMarginCategory AS Movement
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.isErased   = FALSE
         
                         LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                                     ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                                 
                         LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                               ON ObjectFloat_MinPrice.ObjectId = MovementItem.ObjectId
                                              AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                   )
   -- категория наценки и %                  
  , MarginCondition AS (SELECT D1.MovementId
                             , D1.MarginCategoryItemId
                             , D1.Amount AS MarginPercent
                             , D1.PercentNew
                             , D1.AmountDiff
                             , D1.MinPrice
                             , COALESCE(D2.MinPrice, 1000000) AS MaxPrice 
                        FROM tmpMI_Child AS D1
                            LEFT OUTER JOIN tmpMI_Child AS D2 ON D1.MovementId = D2.MovementId
                                                              AND D1.ORD = D2.ORD-1
                        )     
    --строки мастера
  , tmpMI_Master AS (SELECT Movement.Id AS MovementId
                          , Movement.InvNumber
                          , Movement.OperDate
                          , Movement.OperDateStart
                          , Movement.OperDateEnd
                          , MovementItem.Id
                          , MovementItem.ObjectId
                     FROM tmpMarginCategory AS Movement
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                    )
  , tmpMIFloat AS (SELECT MIFloat.*
                   FROM (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master) AS tmp_MI
                        LEFT JOIN MovementItemFloat AS MIFloat ON MIFloat.MovementItemId = tmp_MI.Id
                                                   AND MIFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_Amount())
                  )

       -- результат
       SELECT tmpMI_Master.MovementId
            , tmpMI_Master.InvNumber       ::Integer
            , tmpMI_Master.OperDate
            , tmpMI_Master.OperDateStart
            , tmpMI_Master.OperDateEnd
                          
            , Object_Goods.Id              ::Integer   AS GoodsId
            , Object_Goods.ObjectCode      ::Integer   AS GoodsCode
            , Object_Goods.ValueData       ::TVarChar  AS GoodsName
 
            , COALESCE (MarginCondition.AmountDiff, 0)      ::TFloat   AS AmountDiff
            , COALESCE (MarginCondition.MarginPercent, 0)   ::TFloat   AS MarginPercent
            , COALESCE (MarginCondition.PercentNew, 0)      ::TFloat   AS MarginPercentNew
            , COALESCE (MIFloat_Price.ValueData, 0)         ::TFloat   AS Price
            , COALESCE (MIBoolean_Checked.ValueData, FALSE) ::Boolean  AS isChecked
       FROM tmpMI_Master
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Master.ObjectId

            LEFT JOIN tmpMIFloat AS MIFloat_Amount
                                 ON MIFloat_Amount.MovementItemId = tmpMI_Master.Id
                                AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                       
            LEFT JOIN tmpMIFloat AS MIFloat_Price
                                 ON MIFloat_Price.MovementItemId = tmpMI_Master.Id
                                AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                          ON MIBoolean_Checked.MovementItemId = tmpMI_Master.Id
                                         AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

            LEFT JOIN MarginCondition ON MarginCondition.MovementId = tmpMI_Master.MovementId
                                     AND COALESCE (MIFloat_Price.ValueData, 0) >= MarginCondition.MinPrice AND COALESCE (MIFloat_Price.ValueData, 0) < MarginCondition.MaxPrice
           ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.12.17         * 
*/

-- тест
-- 
--SELECT * FROM lpSelect_MarginCategory_Goods (inUnitId:= 183292 , inGoodsId:= 0, inOperDate:= CURRENT_DATE , inSession:= '3');