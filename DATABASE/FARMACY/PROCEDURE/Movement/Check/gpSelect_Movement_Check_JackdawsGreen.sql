--  gpSelect_Movement_Check_JackdawsGreen()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_JackdawsGreen (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_JackdawsGreen(
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE vbLanguage TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   --vbUnitId := 0;

   SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
   INTO vbLanguage
   FROM Object AS Object_User
                 
        LEFT JOIN ObjectString AS ObjectString_Language
               ON ObjectString_Language.ObjectId = Object_User.Id
              AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
   WHERE Object_User.Id = vbUserId;    

   CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
   SELECT Movement.*
   FROM Movement

        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND (vbUnitId= 0 OR MovementLinkObject_Unit.ObjectId = vbUnitId)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                     ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                    AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
        LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                     ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                    AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                    
   WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
     AND Movement.StatusId = zc_Enum_Status_Complete()
     AND Movement.DescId = zc_Movement_Check()
     AND COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 10413041
     AND (COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0
      OR COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0));
      
  ANALYSE tmpMov;

     -- Результат
  OPEN Cursor1 FOR (
  SELECT
     Movement.Id,
     Movement.InvNumber,
     Movement.OperDate,

     Object_Unit.ID            AS UnitID,
     Object_Unit.ObjectCode    AS UnitCode,
     Object_Unit.ValueData     AS UnitName,

     MovementFloat_TotalSumm.ValueData                  AS TotalSumm
  FROM tmpMov AS Movement

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                               ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                              AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

  ORDER BY Movement.OperDate);

  RETURN NEXT Cursor1;

  OPEN Cursor2 FOR (
      WITH
          tmpMI AS (SELECT MovementItem.Id
                         , MovementItem.Amount
                         , MovementItem.ObjectId
                         , MovementItem.MovementId
                    FROM MovementItem
                    WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     > 0
                   )
        , tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                        )
        , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        )
        , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        )
        , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                        )
        , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                              , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                       )
        , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                              WHERE MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI))

       , tmpMI_Sum AS (SELECT  MovementItem.*
                             , MIFloat_Price.ValueData             AS Price
                             , MIFloat_PriceSale.ValueData         AS PriceSale
                             , MIFloat_ChangePercent.ValueData     AS ChangePercent
                             , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                             , MIFloat_AmountOrder.ValueData       AS AmountOrder
                             , MIFloat_MovementItem.ValueData      AS PricePartionDate
                             , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                                               , COALESCE (MB_RoundingDown.ValueData, False)
                                               , COALESCE (MB_RoundingTo10.ValueData, False)
                                               , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
                             , MIString_UID.ValueData              AS List_UID
                         FROM tmpMI AS MovementItem

                            LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                                        ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                            LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                            LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                            LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                            LEFT JOIN tmpMIFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
                            LEFT JOIN tmpMovementBoolean AS MB_RoundingTo10
                                                      ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                                     AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                            LEFT JOIN tmpMovementBoolean AS MB_RoundingDown
                                                      ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                                     AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                            LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                                      ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                                     AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
                            LEFT JOIN tmpMIString AS MIString_UID
                                                         ON MIString_UID.MovementItemId = MovementItem.Id
                                                        AND MIString_UID.DescId = zc_MIString_UID()
                        )
     -- Результат
     SELECT
           MovementItem.Id          AS Id,
           MovementItem.MovementId  AS MovementId
         , MovementItem.ObjectId    AS GoodsId
         , Object_Goods_Main.ObjectCode  AS GoodsCode
         , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                THEN Object_Goods_Main.NameUkr
                ELSE Object_Goods_Main.Name END   AS GoodsName
         , MovementItem.Amount      AS Amount
         , MovementItem.Price       AS Price
         , MovementItem.AmountSumm  AS Summ
         , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS
         , MovementItem.PriceSale              AS PriceSale
         , MovementItem.ChangePercent          AS ChangePercent
         , MovementItem.SummChangePercent      AS SummChangePercent
         , False                               AS isErased

         , zc_Color_White()                    AS Color_Calc

         , Object_PartionDateKind.Id                                           AS PartionDateKindId
         , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
         , MovementItem.PricePartionDate                                       AS PricePartionDate

         , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId) AS  NDSKindId

     FROM tmpMI_Sum AS MovementItem

        INNER JOIN tmpMov AS Movement ON Movement.ID = MovementItem.MovementId

        LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

        LEFT JOIN tmpMILinkObject AS MILinkObject_NDSKind
                                         ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

        LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                             ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)

        --Типы срок/не срок
        LEFT JOIN tmpMILinkObject AS MI_PartionDateKind
                                  ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                 AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
        LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
                                                  AND Object_PartionDateKind.DescId = zc_Object_PartionDateKind()

        LEFT JOIN tmpMILinkObject AS MILinkObject_DiscountExternal
                                         ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                        AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
        LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

        LEFT JOIN tmpMILinkObject AS MILinkObject_DivisionParties
                                  ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                 AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
        LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId

     );

  RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.08.21                                                       *    
*/

-- тест
--
select * from gpSelect_Movement_Check_JackdawsGreen(inSession := '3');