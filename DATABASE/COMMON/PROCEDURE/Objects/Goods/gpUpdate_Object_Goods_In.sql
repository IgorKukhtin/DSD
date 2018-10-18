 -- Function: gpUpdate_Object_Goods_In(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_In (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_In(
    IN inStartDate           TDateTime,    --
    IN inEndDate             TDateTime,    --
    IN inSession             TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

   CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
      -- ограничиваем товар
      INSERT INTO tmpGoods (GoodsId)
        SELECT DISTINCT Object_Goods.Id AS GoodsId
        FROM Object_InfoMoney_View
             JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                        AND Object_Goods.isErased = FALSE
        WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100()
                                                             , zc_Enum_InfoMoneyDestination_20200()
                                                             , zc_Enum_InfoMoneyDestination_20300());



   -- сохраняем свойства
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_In(), tmpDataAll.GoodsId, tmpDataAll.OperDate)                       -- сохранили свойство <Дата посл. прихода>
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_PartnerIn(), tmpDataAll.GoodsId, MovementLinkObject_From.ObjectId)   -- сохранили свойство <Поставщик>
      
         , lpInsert_ObjectProtocol (inObjectId:= tmpDataAll.GoodsId, inUserId:= vbUserId, inIsUpdate:= FALSE)
   FROM (-- берем последний документ прихода
         SELECT tmpDataAll.* 
         FROM
             
             (-- все документы прихода
              SELECT MovementItem.ObjectId AS GoodsId
                   , Movement.Id           AS MovementId
                   , Movement.OperDate     AS OperDate
                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.Id desc, Movement.OperDate desc) as Ord
              FROM (                
                    SELECT Movement.Id
                         , Movement.OperDate
                    FROM Movement 
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate  -- '01.09.2018' AND '18.10.2018'  --
                      AND Movement.DescId = zc_Movement_Income() 
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    ) AS Movement
                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                      INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
              ) AS tmpDataAll
         WHERE  tmpDataAll.Ord = 1
         ) AS tmpDataAll
           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = tmpDataAll.MovementId
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         ;

END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.18         *
*/
