-- Function: gpReport_TopListDiffGoods()

DROP FUNCTION IF EXISTS gpReport_TopListDiffGoods (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TopListDiffGoods(
    IN inStartDate     TDateTime,  -- Дата начала
    IN inEndDate       TDateTime,  -- Дата окончания
    IN inUnitId        Integer  ,  -- Подразделение
    IN inТop           Integer,  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1          refcursor;
  DECLARE cur2          refcursor;

  DECLARE curUnit       refcursor;
  DECLARE vbOrd         Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbQueryText   Text;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
    (WITH tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId   AS UnitId
                             FROM Movement

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    

                             WHERE Movement.DescId         = zc_Movement_Check()
                               AND Movement.OperDate > CURRENT_DATE - INTERVAL '14 DAY')

     SELECT row_number()OVER(ORDER BY tmpUnit.UnitId)  AS Ord
          , tmpUnit.UnitId
          , Objectt_Unit.ValueData                     AS UnitName
     FROM tmpUnit

          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = tmpUnit.UnitId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4
     
     
          INNER JOIN Object AS Objectt_Unit ON Objectt_Unit.ID = tmpUnit.UnitId
    );
  
  CREATE TEMP TABLE tmpListDiff ON COMMIT DROP AS
    (WITH tmpMovement AS (SELECT MovementListDiff.ID
                               , MovementListDiff.InvNumber
                               , MovementListDiff.OperDate  
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM Movement AS MovementListDiff

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = MovementListDiff.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()

                          WHERE MovementListDiff.OperDate BETWEEN inStartDate AND inEndDate
                            AND MovementListDiff.DescId = zc_Movement_ListDiff() 
                            AND MovementListDiff.StatusId = zc_Enum_Status_Complete()
                            AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0))                         
        , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                         , Movement.InvNumber
                         , Movement.OperDate
                         , MovementItem.ObjectId                                                          AS GoodsID
                         , MovementItem.Id                                                                AS MovementItemId
                         , MovementItem.Amount                                                            AS Amount
                         , COALESCE(MIFloat_Price.ValueData,0)                                            AS Price
                    FROM tmpMovement as Movement
                       
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE
                                                AND MovementItem.Amount > 0 

                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                       
                    )     
        , tmpMISum AS (SELECT tmpMI.GoodsID                                        AS GoodsID
                            , SUM(tmpMI.Amount)::TFloat                            AS Amount
                            , SUM(ROUND(tmpMI.Price * tmpMI.Amount, 2))::TFloat    AS Summa
                       FROM tmpMI
                       GROUP BY tmpMI.GoodsID
                       ORDER BY 2 DESC  
                       LIMIT inТop)

      SELECT ROW_NUMBER() OVER (ORDER BY tmpMISum.Amount DESC)::Integer  AS Ord
           , Object_Goods.Id                                             AS GoodsId
           , Object_Goods.ObjectCode                                     AS GoodsCode
           , Object_Goods.ValueData                                      AS GoodsName
           , tmpMISum.Amount                                             AS Amount
           , ROUND(tmpMISum.Summa / tmpMISum.Amount, 2)::TFloat          AS Price
           , tmpMISum.Summa                                              AS Summa
           , 0::TFloat                                                   AS RemainsAll
      FROM tmpMISum

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMISum.GoodsID

      );
  
    -- Данные для размножения
    OPEN curUnit FOR
        SELECT tmpUnit.Ord
             , tmpUnit.UnitId  
        FROM tmpUnit
        ORDER BY tmpUnit.Ord;
                  
     -- начало цикла по курсору1
     LOOP
        -- данные по курсору1
        FETCH curUnit INTO vbOrd, vbUnitId;
        -- если данные закончились, тогда выход
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpListDiff ADD COLUMN Remains'||vbOrd::TVarChar || ' TFloat, ADD COLUMN Color_calc'||vbOrd::TVarChar || ' Integer NOT NULL DEFAULT zc_Color_Yelow()';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpListDiff SET Remains'||vbOrd::Text||' = (SELECT SUM (Container.Amount) AS Amount
           FROM Container
           WHERE Container.DescId = zc_Container_Count()
             AND Container.ObjectId = tmpListDiff.GoodsID
             AND Container.WhereObjectId = '||vbUnitId::Text||')';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpListDiff SET RemainsAll = RemainsAll + COALESCE(Remains'||vbOrd::TVarChar || ', 0), 
                        Color_calc'||vbOrd::TVarChar || ' = CASE WHEN COALESCE(Remains'||vbOrd::TVarChar || ', 0) > 0 THEN zc_Color_Lime() ELSE zc_Color_Yelow() END';
        EXECUTE vbQueryText;

    END LOOP; -- финиш цикла по курсору1
    CLOSE curUnit; -- закрыли курсор1 
    
    -- Результаты

    -- возвращаем заголовки столбцов
    OPEN cur1 FOR SELECT *
                  FROM tmpUnit
                  ORDER BY tmpUnit.Ord;
    RETURN NEXT cur1;  

    OPEN cur2 FOR SELECT *
                  FROM tmpListDiff
                  ORDER BY tmpListDiff.Ord;
    RETURN NEXT cur2;  
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_TopListDiffGoods (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.10.21                                                       *
*/

-- тест
--

select * from gpReport_TopListDiffGoods(inStartDate := '01.10.2021', inEndDate := '30.10.2021', inUnitId := 0, inТop := 100, inSession := '3');

