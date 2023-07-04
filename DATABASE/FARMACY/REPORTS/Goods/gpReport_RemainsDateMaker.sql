-- Function:  gpReport_RemainsDateMaker()

DROP FUNCTION IF EXISTS gpReport_RemainsDateMaker (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsDateMaker (
  inOperDate TDateTime,
  inMaker Integer,
  inSession TVarChar
)
RETURNS TABLE (
  GoodsId integer,
  GoodsName TVarChar,
  OKPO TVarChar,
  UnitID integer,
  UnitName TVarChar,
  OperDate TDateTime,
  FromId integer,
  FromName TVarChar,

  Remains TFloat
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   WITH
    tmpGoodsPromo AS (SELECT MI_Goods.ObjectId                  AS GoodsID
                           , MAX(MIFloat_Price.ValueData)       AS Price
                      FROM Movement

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                         ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                        AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

                           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                  AND MI_Goods.DescId = zc_MI_Master()
                                                  AND MI_Goods.isErased = FALSE

                           INNER JOIN MovementDate AS MovementDate_StartPromo
                                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                           INNER JOIN MovementDate AS MovementDate_EndPromo
                                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      WHERE Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Promo()
                        AND MovementDate_StartPromo.ValueData <= inOperDate
                        AND MovementDate_EndPromo.ValueData >= inOperDate
                        AND MovementLinkObject_Maker.ObjectId = inMaker
                      GROUP BY MI_Goods.ObjectId),
    tmpGoods AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                      , tmpGoodsPromo.Price 
                 FROM tmpGoodsPromo
                               -- !!!
                      INNER JOIN ObjectLink AS ObjectLink_Child
                                            ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId 
                                           AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                      INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                 AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                 WHERE  ObjectLink_Child_R.ChildObjectId<>0
                      ), 
    tmpContainer AS (SELECT Container.ID                               AS ID
                          , Container.ObjectId                         AS GoodsId
                          , Container.WhereObjectId                    AS UnitId
                          , Container.Amount                           AS Amount 
                     FROM tmpGoods
                          INNER JOIN Container AS Container
                                               ON Container.ObjectId = tmpGoods.GoodsId
                                              AND Container.DescId   = zc_Container_Count() 
                     ),
    tmRemains AS (SELECT Container.ID                                  AS ID
                       , Container.GoodsId                             AS GoodsId
                       , Container.UnitID                              AS UnitID
                        
                       , (Container.Amount - COALESCE(Sum(MovementItemContainer.Amount), 0))::TFloat   AS Remains
                  FROM tmpContainer AS Container
                        
                       INNER JOIN MovementItemContainer AS MovementItemContainer
                                                        ON MovementItemContainer.ContainerId = Container.Id
                                                       AND MovementItemContainer.OperDate >= inOperDate
                                                              
                  
                  GROUP BY Container.ID
                         , Container.GoodsId
                         , Container.UnitID
                         , Container.Amount
                  HAVING Container.Amount - COALESCE(Sum(MovementItemContainer.Amount), 0) > 0),
    tmpRemainsIncome AS (SELECT Container.Id
                              , Container.GoodsId
                              , Container.UnitID
                              , Container.Remains
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)      AS IncomeId
                        FROM tmRemains AS Container
                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                           ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                          AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                             -- элемент прихода
                             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
                         ),
    tmpRemainsJouridical AS (SELECT Container.Id
                                  , Container.GoodsId
                                  , Container.UnitID
                                  , MovementLinkObject_From.ObjectId   AS FromId
                                  , Movement.OperDate
                                  , Sum(Container.Remains)::TFloat     AS Remains
                             FROM tmpRemainsIncome AS Container
                              
                                  INNER JOIN Movement ON Movement.Id = Container.IncomeId
                                   
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              
                             GROUP BY Container.Id
                                    , Container.GoodsId
                                    , Container.UnitID
                                    , Movement.OperDate
                                    , MovementLinkObject_From.ObjectId 
                             )
                  
                  

   SELECT
      Object_Goods.ObjectCode          AS GoodsId
    , Object_Goods.ValueData           AS GoodsName
    , ObjectHistory_JuridicalDetails.OKPO
    , Object_Unit.ObjectCode           AS UnitID
    , Object_Unit.ValueData            AS UnitName
    , Remains.OperDate
    , Object_From.ObjectCode           AS FromId
    , Object_From.ValueData            AS FromName
    
    , Remains.Remains                  AS Remains
    
   FROM tmpRemainsJouridical AS Remains

        INNER JOIN Object AS Object_Unit
                          ON Object_Unit.ID = Remains.UnitID
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Remains.GoodsID
        INNER JOIN Object AS Object_From
                          ON Object_From.Id = Remains.FromId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                            
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

        LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_Unit_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := '3') AS ObjectHistory_JuridicalDetails ON 1=1

   WHERE Object_Unit.ID not in (10129562, 11299914, 11460971, 12812109, 14890823)
     AND ObjectLink_Unit_Parent.ChildObjectId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)
     AND Remains.UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0
);



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.07.23                                                       *

*/

-- тест
-- 

select * from gpReport_RemainsDateMaker ('01.07.2023', 2336633 , '3');