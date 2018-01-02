-- Function:  gpReport_Movement_Check()

DROP FUNCTION IF EXISTS gpReport_Check_UKTZED (Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_UKTZED (Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_UKTZED (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_UKTZED(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- юр.лицо
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inisMovement         Boolean  ,  -- по документам
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitCode          Integer
             , UnitName          TVarChar
             , OurJuridicalName  TVarChar
             , CashRegisterName  TVarChar

             , Code_Fiscal          Integer
             , Name_Fiscal          TVarChar
             , FiscalCheckNumber    TVarChar
             , SerialNumber_Fiscal  TVarChar
             , UnitName_Fiscal      TVarChar
             
             , InvNumber         TVarChar
             , OperDate          TDateTime
             , GoodsId           Integer
             , GoodsCode         Integer
             , GoodsName         TVarChar
             , CodeUKTZED        TVarChar
             , NDSKindName       TVarChar
             , MeasureName       TVarChar
             , Amount            TFloat
             , PriceSale         TFloat
             , SummaSale         TFloat
             , isSp_Check        Boolean
           

)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- Результат
    RETURN QUERY
    WITH
   
    tmpUnit AS (SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0
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
             )
             
  , tmpData_Container AS (SELECT MIContainer.MovementId                      AS MovementId_Check
                               , COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                               , MIContainer.WhereObjectId_analyzer          AS UnitId
                               , MIContainer.ObjectId_analyzer               AS GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                               
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                            --AND MIContainer.WhereObjectId_analyzer = inUnitId
                           -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                          GROUP BY MIContainer.MovementId
                                 , COALESCE (MIContainer.AnalyzerId,0)
                                 , MIContainer.ObjectId_analyzer 
                                 , MIContainer.WhereObjectId_analyzer
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                          )
  , tmpGoods_UKTZED AS (SELECT DISTINCT 
                               tmp.GoodsId                            AS GoodsId      -- код товара сети
                             --, ObjectLink_Goods_Object.ObjectId       AS GoodsId_Jur  -- код товара поставщика
                             , ObjectLink_Goods_Object.ChildObjectId  AS JuridicalId  -- поставщик
                             , ObjectString_Goods_UKTZED.ValueData    AS CodeUKTZED   --
                        FROM (SELECT DISTINCT tmpData_Container.GoodsId FROM tmpData_Container) tmp
                             INNER JOIN ObjectLink AS ObjectLink_Child
                                                   ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                  AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                             LEFT JOIN ObjectLink AS ObjectLink_Main 
                                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                        
                             INNER JOIN ObjectLink AS ObjectLink_Main_Juridical 
                                                   ON ObjectLink_Main_Juridical.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                  AND ObjectLink_Main_Juridical.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                             INNER JOIN ObjectLink AS ObjectLink_Child_Juridical
                                                  ON ObjectLink_Child_Juridical.ObjectId = ObjectLink_Main_Juridical.ObjectId
                                                 AND ObjectLink_Child_Juridical.DescId   = zc_ObjectLink_LinkGoods_Goods()  
                             INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                   ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_Juridical.ChildObjectId
                                                  AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                             INNER JOIN Object AS Object_Juridical 
                                               ON Object_Juridical.Id     = ObjectLink_Goods_Object.ChildObjectId
                                              AND Object_Juridical.DescId = zc_Object_Juridical()
                        
                             LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                                    ON ObjectString_Goods_UKTZED.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                   AND ObjectString_Goods_UKTZED.DescId   = zc_ObjectString_Goods_UKTZED()
                 )
              
  , tmpFiscal AS (SELECT Object_Fiscal.ObjectCode    AS Code
                       , Object_Fiscal.ValueData     AS Name
                       , ObjectString_SerialNumber.ValueData  AS SerialNumber
                       , ObjectString_InvNumber.ValueData     AS InvNumber
                       , Object_Unit.Id              AS UnitId 
                       , Object_Unit.ValueData       AS UnitName 
                  FROM Object AS Object_Fiscal
                      INNER JOIN ObjectString AS ObjectString_InvNumber
                                              ON ObjectString_InvNumber.ObjectId = Object_Fiscal.Id 
                                             AND ObjectString_InvNumber.DescId = zc_ObjectString_Fiscal_InvNumber()
                                             AND COALESCE (ObjectString_InvNumber.ValueData, '') <> ''
                                            
                      LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                             ON ObjectString_SerialNumber.ObjectId = Object_Fiscal.Id 
                                            AND ObjectString_SerialNumber.DescId = zc_ObjectString_Fiscal_SerialNumber()
                                                                       
                      LEFT JOIN ObjectLink AS ObjectLink_Fiscal_Unit
                                           ON ObjectLink_Fiscal_Unit.ObjectId = Object_Fiscal.Id 
                                          AND ObjectLink_Fiscal_Unit.DescId = zc_ObjectLink_Fiscal_Unit()
                      LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Fiscal_Unit.ChildObjectId
                  WHERE Object_Fiscal.DescId = zc_Object_Fiscal()
                  ) 
         
  , tmpData_Det AS (SELECT tmpData_Container.MovementId_Check
                        , CASE WHEN COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' THEN TRUE ELSE FALSE END AS isSp_Check
                        , MovementLinkObject_CashRegister.ObjectId                                                    AS CashRegisterId
                        , COALESCE (MovementString_FiscalCheckNumber.ValueData, '')                        ::TVarChar AS FiscalCheckNumber
                       
                   FROM (SELECT DISTINCT tmpData_Container.MovementId_Check FROM tmpData_Container) AS tmpData_Container
                        LEFT JOIN MovementString AS MovementString_InvNumberSP
                                                 ON MovementString_InvNumberSP.MovementId = tmpData_Container.MovementId_Check
                                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                        -- касса
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                     ON MovementLinkObject_CashRegister.MovementId = tmpData_Container.MovementId_Check
                                                    AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                        LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                                 ON MovementString_FiscalCheckNumber.MovementId = tmpData_Container.MovementId_Check
                                                AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                   )
                   
  , tmpData_all AS (SELECT CASE WHEN inisMovement = TRUE THEN tmpData_Container.MovementId_Check ELSE 0 END AS MovementId_Check
                         , MI_Income.Id                         :: Integer AS MovementItemId
                         , MI_Income.MovementId                 :: Integer AS MovementId
                         , tmpData_Det.CashRegisterId
                         , tmpData_Det.isSp_Check
                         , tmpData_Det.FiscalCheckNumber
                         , tmpData_Container.UnitId
                         , tmpData_Container.GoodsId
                         , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                         , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                    FROM tmpData_Container
                         LEFT JOIN tmpData_Det ON tmpData_Det.MovementId_Check = tmpData_Container.MovementId_Check
                          -- элемент прихода
                         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId_Income
                   GROUP BY MI_Income.Id
                          , MI_Income.MovementId
                          , tmpData_Container.GoodsId
                          , tmpData_Container.UnitId
                          , CASE WHEN inisMovement = TRUE THEN tmpData_Container.MovementId_Check ELSE 0 END
                          , tmpData_Det.CashRegisterId
                          , tmpData_Det.isSp_Check
                          , tmpData_Det.FiscalCheckNumber
                         )
                         
  -- находим CodeUKTZED из партии прихода, если значение пустое берем из свойства товара
  , tmpData AS (SELECT tmpData_all.MovementId_Check            AS MovementId_Check
                     , tmpData_all.isSp_Check
                     , COALESCE (MIString_FEA.ValueData, tmpGoods_UKTZED.CodeUKTZED)  AS CodeUKTZED
                     , tmpData_all.CashRegisterId
                     , tmpData_all.FiscalCheckNumber
                     , tmpData_all.UnitId
                     , tmpData_all.GoodsId

                     , tmpData_all.Amount    AS Amount
                     , tmpData_all.SummaSale AS SummaSale
                FROM tmpData_all
                     LEFT JOIN MovementItemString AS MIString_FEA
                                                  ON MIString_FEA.MovementItemId = tmpData_all.MovementItemId
                                                 AND MIString_FEA.DescId = zc_MIString_FEA()
                                                 AND MIString_FEA.ValueData <> ''
                     -- Поставшик, для элемента прихода от поставщика (или NULL)
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                  ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                 AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                                
                     -- если MIString_FEA пустое берем из свойства товара
                     LEFT JOIN tmpGoods_UKTZED ON tmpGoods_UKTZED.GoodsId     = tmpData_all.GoodsId
                                              AND tmpGoods_UKTZED.JuridicalId = MovementLinkObject_From_Income.ObjectId
--and 1=0
               )

  
  , tmpDataRez AS (SELECT tmpData.MovementId_Check
                        , tmpData.CashRegisterId
                        , tmpData.FiscalCheckNumber
                        , tmpData.UnitId
                        , tmpData.GoodsId
                        , tmpData.CodeUKTZED
                        , tmpData.isSp_Check
                        , SUM (tmpData.Amount)     AS Amount
                        , SUM (tmpData.SummaSale)  AS SummaSale
                        , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.SummaSale) / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS PriceSale
                   FROM tmpData
                   GROUP BY tmpData.MovementId_Check
                          , tmpData.CashRegisterId
                          , tmpData.FiscalCheckNumber
                          , tmpData.UnitId
                          , tmpData.GoodsId
                          , tmpData.CodeUKTZED
                          , tmpData.isSp_Check
                   )

        -- результат
        SELECT
             Object_Unit.ObjectCode                       AS UnitCode
           , Object_Unit.ValueData                        AS UnitName
           , Object_OurJuridical.ValueData                AS OurJuridicalName
           , Object_CashRegister.ValueData                AS CashRegisterName
           
           , tmpFiscal.Code                               AS Code_Fiscal
           , tmpFiscal.Name                               AS Name_Fiscal
           , tmpData.FiscalCheckNumber                    AS FiscalCheckNumber
           , tmpFiscal.SerialNumber                       AS SerialNumber_Fiscal
           , tmpFiscal.UnitName                           AS UnitName_Fiscal

           , Movement_Check.InvNumber                     AS InvNumber
           , Movement_Check.OperDate                      AS OperDate

           , Object_Goods.Id                              AS GoodsId
           , Object_Goods.ObjectCode                      AS GoodsCode
           , Object_Goods.ValueData                       AS GoodsName
           , tmpData.CodeUKTZED                           AS CodeUKTZED

           , Object_NDSKind.ValueData                     AS NDSKindName
           , Object_Measure.ValueData                     AS MeasureName

           , tmpData.Amount                    ::TFloat   AS Amount
           , tmpData.PriceSale                 ::TFloat   AS PriceSale
           , tmpData.SummaSale                 ::TFloat   AS SummaSale

           , tmpData.isSp_Check                ::Boolean  AS isSp_Check

      
        FROM tmpDataRez AS tmpData

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                          
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical         
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_OurJuridical ON Object_OurJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN Movement AS Movement_Check ON Movement_Check.Id = tmpData.MovementId_Check
             
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = tmpData.CashRegisterId

             LEFT JOIN tmpFiscal ON tmpFiscal.InvNumber = tmpData.FiscalCheckNumber
                                AND tmpFiscal.UnitId    = tmpData.UnitId
        ORDER BY Object_Goods.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 12.12.17         *
*/

-- тест
-- select * from gpReport_Check_UKTZED(inUnitId := 183292 , inRetailId := 0 , inStartDate := ('03.10.2016')::TDateTime , inEndDate := ('03.10.2016')::TDateTime , inIsMovement := 'True' ::Boolean,  inSession := '3'::tvarchar);
