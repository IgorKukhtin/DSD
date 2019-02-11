-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_ListDiff (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_ListDiff(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inDiffKindId       Integer  ,
    IN inisUnitList       Boolean  ,  -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer, 
               GoodsCode      Integer, 
               GoodsName      TVarChar,
               GoodsGroupName TVarChar,
               DiffKindId     Integer,
               DiffKindName   TVarChar,
               Price          TFloat,
               Amount         TFloat,
               Summa          TFloat,
               isTOP    Boolean,
               isFirst  Boolean,
               isSecond Boolean,
               isClose  Boolean,
               isPromo  Boolean,
               isSP     Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
        tmpUnit AS (SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE
             )

      -- Виды отказов
      , tmpDiffKind AS (SELECT Object_DiffKind.Id                     AS Id
                             , Object_DiffKind.ObjectCode             AS Code
                             , Object_DiffKind.ValueData              AS Name
                             , COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) AS isClose
                        FROM Object AS Object_DiffKind
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                     ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                                    AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
                        WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
                          AND Object_DiffKind.isErased = FALSE
                        )

      , tmpMovement AS (SELECT Movement_ListDiff.Id             AS Id
                                     , MovementLinkObject_Unit.ObjectId AS UnitId
                                FROM Movement AS Movement_ListDiff
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement_ListDiff.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                WHERE Movement_ListDiff.DescId = zc_Movement_ListDiff()
                                  AND Movement_ListDiff.OperDate >= inStartDate
                                  AND Movement_ListDiff.OperDate < inEndDate + INTERVAL '1 DAY'
                              )

      , tmpData_MI AS (SELECT /*COALESCE (MIFloat_OrderId.ValueData       :: Integer AS MovementId_Order
                            , */MovementItem.ObjectId                                AS GoodsId
                            , MILO_DiffKind.ObjectId                               AS DiffKindId
                            , MI_Float_Price.ValueData                             AS Price
                            , SUM (MovementItem.Amount)                            AS Amount
                            , SUM (MI_Float_Price.ValueData * MovementItem.Amount) AS Summa
                       FROM tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                             ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                            AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_OrderId
                                                        ON MIFloat_OrderId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OrderId.DescId         = zc_MIFloat_MovementId()
                            LEFT JOIN MovementItemFloat AS MI_Float_Price
                                                        ON MI_Float_Price.MovementItemId = MovementItem.Id
                                                       AND MI_Float_Price.DescId = zc_MIFloat_Price()
                       WHERE MILO_DiffKind.ObjectId = inDiffKindId OR inDiffKindId = 0
                       GROUP BY /*COALESCE (MIFloat_OrderId.ValueData
                              , */MovementItem.ObjectId
                              , MILO_DiffKind.ObjectId
                              , MI_Float_Price.ValueData
                       )
/*      , tmpMovementOrder AS (SELECT Movement.*
                             FROM (SELECT DISTICT tmpData_MI.MovementId_Order FROM tmpData_MI) AS tmp
                                  LEFT JOIN Movement ON Movement.Id = tmp.MovementId_Order
                             )*/

--      , tmpGoods_Params AS ()
      -- Маркетинговый контракт
      , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                                     , ObjectLink_Goods_Object.ChildObjectId AS ObjectId
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                       --  AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                         )

       -- Товары соц-проект (документ)
        , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                         FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate) AS tmp
                         )
                          
        SELECT
             Object_Goods_View.Id                      AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer AS GoodsCode
           , Object_Goods_View.GoodsName               AS GoodsName
           , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
           , tmpDiffKind.Id                     AS DiffKindId
           , tmpDiffKind.Name                   AS DiffKindName
           , tmpData.Price             ::TFloat AS Price
           , tmpData.Amount            ::TFloat AS Amount
           , tmpData.Summa             ::TFloat AS Summa
           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
           , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
           , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond
           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
           , CASE WHEN COALESCE (GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
           , COALESCE (tmpGoodsSP.isSP, False)                     :: Boolean AS isSP
        FROM tmpData_MI AS tmpData
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId
            
            LEFT JOIN tmpDiffKind ON tmpDiffKind.Id = tmpData.DiffKindId

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                        ON ObjectBoolean_Goods_First.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                        ON ObjectBoolean_Goods_Second.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
            -- получается GoodsMainId
            LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = tmpData.GoodsId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Main
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
            /*LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                                    ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                   AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/

        ORDER BY GoodsGroupName
               , GoodsName;
----

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         * признак Товары соц-проект берем и документа
 21.12.18         *
*/

-- тест
-- select * from gpReport_Movement_ListDiff(inStartDate := ('01.12.2018')::TDateTime, inEndDate := ('12.12.2018')::TDateTime, inJuridicalId := 0, inUnitId := 0 , inRetailId:= 0 , inDiffKindId := 0, inisUnitList := TRUE ,  inSession := '3');