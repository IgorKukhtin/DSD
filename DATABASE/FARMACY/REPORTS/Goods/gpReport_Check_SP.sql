-- Function:  gpReport_Check_SP()

DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_SP(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inUnitId           Integer  ,  -- Аптека
    IN inHospitalId       Integer  ,  -- Больница
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitName       TVarChar
             , JuridicalName  TVarChar
             , HospitalName   TVarChar
             , IntenalSPName  TVarChar
             , BrandSPName    TVarChar
             , KindOutSPName  TVarChar
             , Pack           TVarChar
             , CountSP        TFloat
             , PriceSP        TFloat 
             , GroupSP        TFloat 
             , Amount         TFloat 
             , SummaSP        TFloat 
             , NumLine        Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    
    -- Таблицы
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer) ON COMMIT DROP;
 
    IF (COALESCE (inJuridicalId,0) <> 0) OR (COALESCE (inUnitId,0) <> 0) THEN
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ((OL_Unit_Juridical.ChildObjectId = inJuridicalId AND COALESCE (inUnitId,0) = 0)
                          OR OL_Unit_Juridical.ObjectId = inUnitId);
    ELSE 
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
    END IF;

    -- Результат
    RETURN QUERY
          WITH
          -- выбираем товары спец. проекта (главные)
          tmpGoodsSP AS (SELECT ObjectBoolean_Goods_SP.ObjectId              AS GoodsMainId
                              , ObjectLink_Goods_IntenalSP.ChildObjectId     AS IntenalSPId
                              , Object_IntenalSP.ValueData                   AS IntenalSPName
                              , ObjectLink_Goods_BrandSP.ChildObjectId       AS BrandSPId
                              , Object_BrandSP.ValueData                     AS BrandSPName
                              , ObjectLink_Goods_KindOutSP.ChildObjectId     AS KindOutSPId
                              , Object_KindOutSP.ValueData                   AS KindOutSPName

                              , ObjectFloat_Goods_PriceSP.ValueData          AS PriceSP
                              , ObjectFloat_Goods_GroupSP.ValueData          AS GroupSP
                              , ObjectFloat_Goods_CountSP.ValueData          AS CountSP
                              , ObjectString_Goods_Pack.ValueData            AS Pack  --дозировка

                          FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                               LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
        
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_BrandSP
                                 ON ObjectLink_Goods_BrandSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_BrandSP.DescId = zc_ObjectLink_Goods_BrandSP()
                               LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = ObjectLink_Goods_BrandSP.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_KindOutSP
                                 ON ObjectLink_Goods_KindOutSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_KindOutSP.DescId = zc_ObjectLink_Goods_KindOutSP()
                               LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = ObjectLink_Goods_KindOutSP.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                 ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_GroupSP
                                 ON ObjectFloat_Goods_GroupSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_GroupSP.DescId = zc_ObjectFloat_Goods_GroupSP()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountSP
                                 ON ObjectFloat_Goods_CountSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_CountSP.DescId = zc_ObjectFloat_Goods_CountSP()

                               LEFT JOIN ObjectString AS ObjectString_Goods_Pack
                                 ON ObjectString_Goods_Pack.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectString_Goods_Pack.DescId = zc_ObjectString_Goods_Pack()
    
                          WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                            AND ObjectBoolean_Goods_SP.ValueData = TRUE
                         )
           -- связываем главные товары с товарами сети
           , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                               , tmpGoodsSP.GoodsMainId
                          FROM tmpGoodsSP
                               INNER JOIN ObjectLink AS ObjectLink_Main
                                  ON ObjectLink_Main.ChildObjectId = tmpGoodsSP.GoodsMainId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                               INNER JOIN ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 AND COALESCE (ObjectLink_Child.ChildObjectId,0)<>0
                          )
            -- выбираем продажи по товарам соц.проекта
            ,  tmpMI AS (SELECT MovementLinkObject_Unit.ObjectId                          AS UnitId
                              , tmpUnit.JuridicalId
                              , 0                                                         AS HospitalId
                              , tmpGoods.GoodsMainId                                      AS GoodsMainId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0))   AS SummChangePercent
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                              -- еще нужно добавить ограничение по больнице
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE

                              INNER JOIN tmpGoods ON tmpGoods.GoodsId = MI_Check.ObjectId
                              --Сумма Скидки
                              LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                          ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                         AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MovementLinkObject_Unit.ObjectId
                                , tmpUnit.JuridicalId
                                , tmpGoods.GoodsMainId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
      , tmpData AS (SELECT tmpMI.UnitId
                         , tmpMI.JuridicalId
                         , tmpMI.HospitalId
                         , tmpMI.GoodsMainId
                         , tmpMI.Amount
                         , tmpMI.SummChangePercent
                    FROM tmpMI 
                    )

        -- результат
        SELECT Object_Unit.ValueData         AS UnitName
             , Object_Juridical.ValueData    AS JuridicalName
             , Object_Hospital.ValueData     AS HospitalName
             , tmpGoodsSP.IntenalSPName
             , tmpGoodsSP.BrandSPName
             , tmpGoodsSP.KindOutSPName
             , tmpGoodsSP.Pack  ::TVarChar
             , tmpGoodsSP.CountSP :: TFloat 
             , tmpGoodsSP.PriceSP :: TFloat 
             , tmpGoodsSP.GroupSP :: TFloat 
             , tmpData.Amount     :: TFloat 
             , tmpData.SummChangePercent :: TFloat  AS SummaSP
             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Unit.ValueData ORDER BY Object_Unit.ValueData, tmpGoodsSP.IntenalSPName ) AS Integer) AS NumLine
        FROM tmpData
             LEFT JOIN tmpGoodsSP AS tmpGoodsSP ON tmpGoodsSP.GoodsMainId = tmpData.GoodsMainId
          
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Hospital ON Object_Hospital.Id = tmpData.HospitalId

        ORDER BY Object_Unit.ValueData
               , tmpGoodsSP.IntenalSPName
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 20.12.16         *
*/

-- тест
--SELECT * FROM gpReport_Check_SP(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('29.12.2016')::TDateTime,  inSession := '3');
