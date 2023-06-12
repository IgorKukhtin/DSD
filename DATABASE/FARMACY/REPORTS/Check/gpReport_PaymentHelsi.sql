-- Function:  gpReport_PaymentHelsi()

DROP FUNCTION IF EXISTS gpReport_PaymentHelsi (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PaymentHelsi(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;
   DECLARE curTitle refcursor;
   DECLARE vbQueryText Text;
   DECLARE vbId Integer;
   DECLARE vbTotal Text;
   DECLARE vbCount Text;
   DECLARE vbGroupMedicalProgramSPId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    
    -- raise notice 'Value 1: %', CLOCK_TIMESTAMP();
        
    -- выбираем продажи по товарам соц.проекта
    CREATE TEMP TABLE tmpMIC ON COMMIT DROP AS
    SELECT MIC.WhereObjectId_Analyzer                   AS UnitId
         , OL_Unit_Juridical.ChildObjectId              AS JuridicalId
         , MovementLinkObject_MedicalProgramSP.ObjectId AS MedicalProgramSPId
         , MIC.MovementId
         , MIC.MovementItemId
         , MIC.Amount 
    FROM MovementItemContainer AS MIC
                    
         INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                       ON MovementLinkObject_SPKind.MovementId = MIC.MovementId
                                      AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                      AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_SP()
                                                      
         INNER JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                       ON MovementLinkObject_MedicalProgramSP.MovementId = MIC.MovementId
                                      AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                                    
         INNER JOIN ObjectLink AS OL_Unit_Juridical
                               ON OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND OL_Unit_Juridical.ObjectId = MIC.WhereObjectId_Analyzer
                                        
    WHERE MIC.MovementDescId = zc_Movement_Check()
      AND MIC.DescId = zc_MIContainer_Count()
      AND MIC.OperDate >= inStartDate AND MIC.OperDate < inEndDate + INTERVAL '1 DAY';
                      
    ANALYSE tmpMIC;    
    
    -- raise notice 'Value 2: %', CLOCK_TIMESTAMP();

    -- выбираем продажи по товарам соц.проекта
    CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
    SELECT MIC.UnitId
         , MIC.JuridicalId
         , ObjectLink_GroupMedicalProgramSP.ChildObjectId AS GroupMedicalProgramSPId
         , SUM(-1.0 * MIC.Amount * MIFloat_PriceSale.ValueData)::TFloat  AS Summa
    FROM tmpMIC AS MIC
                                                        
         LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                 ON ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()
                                AND ObjectBoolean_ElectronicPrescript.ObjectId = MIC.MedicalProgramSPId

         INNER JOIN ObjectLink AS ObjectLink_GroupMedicalProgramSP
                               ON ObjectLink_GroupMedicalProgramSP.ObjectId = MIC.MedicalProgramSPId
                              AND ObjectLink_GroupMedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP()

         INNER JOIN ObjectLink AS OL_Juridical_Retail
                               ON OL_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              AND OL_Juridical_Retail.ObjectId = MIC.JuridicalId
                              AND OL_Juridical_Retail.ChildObjectId = vbObjectId

         LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                     ON MIFloat_PriceSale.MovementItemId = MIC.MovementItemId
                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                        
    WHERE COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, FALSE) = FALSE
    GROUP BY MIC.UnitId
           , MIC.JuridicalId
           , ObjectLink_GroupMedicalProgramSP.ChildObjectId;
                      
    ANALYSE tmpMI;
    
    -- raise notice 'Value 3: %', CLOCK_TIMESTAMP();
    
    -- выбираем продажи по товарам соц.проекта
    CREATE TEMP TABLE tmpMI_Recipe ON COMMIT DROP AS
    SELECT MIC.UnitId
         , MIC.JuridicalId
         , ObjectLink_GroupMedicalProgramSP.ChildObjectId AS GroupMedicalProgramSPId
         , SUM(-1.0 * MIC.Amount * MIFloat_Price.ValueData)::TFloat  AS Summa
         , Count(DISTINCT MIC.MovementId)::Integer                   AS CountRecipe
    FROM tmpMIC AS MIC
                    
         LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                 ON ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()
                                AND ObjectBoolean_ElectronicPrescript.ObjectId = MIC.MedicalProgramSPId

         INNER JOIN ObjectLink AS ObjectLink_GroupMedicalProgramSP
                               ON ObjectLink_GroupMedicalProgramSP.ObjectId = MIC.MedicalProgramSPId
                              AND ObjectLink_GroupMedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP()
                              
         INNER JOIN ObjectLink AS OL_Juridical_Retail
                               ON OL_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              AND OL_Juridical_Retail.ObjectId = MIC.JuridicalId
                              AND OL_Juridical_Retail.ChildObjectId = vbObjectId

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MIC.MovementItemId
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        
    WHERE COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, FALSE) = TRUE
    GROUP BY MIC.UnitId
           , MIC.JuridicalId
           , ObjectLink_GroupMedicalProgramSP.ChildObjectId;
                      
    ANALYSE tmpMI_Recipe;

    -- raise notice 'Value 4: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpTitle ON COMMIT DROP AS
    WITH tmpData AS (SELECT DISTINCT tmpMI.GroupMedicalProgramSPId 
                     FROM tmpMI
                     UNION All
                     SELECT 0)
                          
    SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(Object_GroupMedicalProgramSP.objectcode, 10000)) AS Id
         , Object_GroupMedicalProgramSP.Id                                                       AS GroupMedicalProgramSPId
         , COALESCE(Object_GroupMedicalProgramSP.ValueData||', грн', 'Всього по ДЛ, грн')               AS Title
    FROM tmpData
         LEFT JOIN Object AS Object_GroupMedicalProgramSP ON Object_GroupMedicalProgramSP.Id = tmpData.GroupMedicalProgramSPId
    ORDER BY COALESCE(Object_GroupMedicalProgramSP.objectcode, 10000)
    ;
    
    ANALYSE tmpTitle;

    CREATE TEMP TABLE tmpTitle_Recipe ON COMMIT DROP AS
    WITH tmpData AS (SELECT DISTINCT tmpMI_Recipe.GroupMedicalProgramSPId 
                     FROM tmpMI_Recipe
                     UNION All
                     SELECT 0)
                          
    SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(Object_GroupMedicalProgramSP.objectcode, 10000)) AS Id
         , Object_GroupMedicalProgramSP.Id                                      AS GroupMedicalProgramSPId
         , COALESCE(Object_GroupMedicalProgramSP.ValueData||', рецептов шт.', 'Всього рецептов шт.')               AS Title1
         , COALESCE(Object_GroupMedicalProgramSP.ValueData||', реализация грн', 'Всього РЛЗ+АЛЗ, грн')             AS Title2
    FROM tmpData
         LEFT JOIN Object AS Object_GroupMedicalProgramSP ON Object_GroupMedicalProgramSP.Id = tmpData.GroupMedicalProgramSPId
    ORDER BY COALESCE(Object_GroupMedicalProgramSP.objectcode, 10000)
    ;
    
    ANALYSE tmpTitle_Recipe;
        
    CREATE TEMP TABLE tmpResult (
            JuridicalId       Integer
          , JuridicalCode     Integer  
          , JuridicalName     TVarChar  
          , UnitId            Integer
          , UnitCode          Integer  
          , UnitName          TVarChar  
    ) ON COMMIT DROP;
    
    
    INSERT INTO tmpResult
    SELECT Object_Juridical.Id
         , Object_Juridical.ObjectCode
         , Object_Juridical.ValueData
         , Object_Unit.Id
         , Object_Unit.ObjectCode
         , Object_Unit.ValueData
    FROM (SELECT DISTINCT tmpMIC.JuridicalId, tmpMIC.UnitId FROM tmpMIC) AS MI

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MI.JuridicalId

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI.UnitId
    ;
    
    ANALYSE tmpResult;

    ---- raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    -- **** Данные по рецептам с скидкой

    -- Заполняем данными 1 проход
    OPEN curTitle FOR
      SELECT tmpTitle.Id
           , tmpTitle.GroupMedicalProgramSPId
      FROM tmpTitle
      ORDER BY tmpTitle.Id;

     -- начало цикла по курсору1
    LOOP
       -- данные по курсору1
       FETCH curTitle INTO vbId, vbGroupMedicalProgramSPId;

       -- если данные закончились, тогда выход
       IF NOT FOUND THEN EXIT; END IF;
       
       vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Summa' || COALESCE (vbId, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
       EXECUTE vbQueryText;
       
       vbTotal := 'Summa' || COALESCE (vbId, 0)::Text;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curTitle; -- закрыли курсор1    
     
    -- Заполняем данными 2 проход
    OPEN curTitle FOR
      SELECT tmpTitle.Id
           , tmpTitle.GroupMedicalProgramSPId
      FROM tmpTitle
      ORDER BY tmpTitle.Id;

     -- начало цикла по курсору1
    LOOP
       -- данные по курсору1
       FETCH curTitle INTO vbId, vbGroupMedicalProgramSPId;

       -- если данные закончились, тогда выход
       IF NOT FOUND THEN EXIT; END IF;
       
       IF COALESCE(vbGroupMedicalProgramSPId, 0) <> 0 
       THEN

         vbQueryText := 'UPDATE tmpResult SET Summa' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.Summa, 0) 
                                            , '||vbTotal||' = '||vbTotal||' + COALESCE (T1.Summa, 0)
                         FROM (SELECT MI.UnitId 
                                    , ROUND(CASE WHEN ' || COALESCE (vbId, 0)::Text || ' = 1
                                                 THEN CASE WHEN SUM(MI.Summa) / 50 > 200 THEN SUM(MI.Summa) / 50 ELSE 200 END
                                                 ELSE SUM(MI.Summa) / 100 END, 2) ::TFloat AS Summa
                               FROM tmpMI as MI
                               WHERE MI.GroupMedicalProgramSPId = '||COALESCE (vbGroupMedicalProgramSPId, 0)::Text||
                               ' GROUP BY MI.UnitId) AS T1
                         WHERE tmpResult.UnitId = T1.UnitId';
         EXECUTE vbQueryText;
         
       END IF;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curTitle; -- закрыли курсор1    
    
    -- **** Данные по рецептам
    
    -- Заполняем данными 1 проход
    OPEN curTitle FOR
      SELECT tmpTitle_Recipe.Id
           , tmpTitle_Recipe.GroupMedicalProgramSPId
      FROM tmpTitle_Recipe
      ORDER BY tmpTitle_Recipe.Id;

     -- начало цикла по курсору1
    LOOP
       -- данные по курсору1
       FETCH curTitle INTO vbId, vbGroupMedicalProgramSPId;

       -- если данные закончились, тогда выход
       IF NOT FOUND THEN EXIT; END IF;
       
       vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Summa_Recipe' || COALESCE (vbId, 0)::Text || ' TFloat NOT NULL DEFAULT 0 '||
                                          ', ADD COLUMN Count_Recipe' || COALESCE (vbId, 0)::Text || ' Integer NOT NULL DEFAULT 0 ';
       EXECUTE vbQueryText;
       
       vbTotal := 'Summa_Recipe' || COALESCE (vbId, 0)::Text;
       vbCount := 'Count_Recipe' || COALESCE (vbId, 0)::Text;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curTitle; -- закрыли курсор1        


    -- Заполняем данными 2 проход
    OPEN curTitle FOR
      SELECT tmpTitle_Recipe.Id
           , tmpTitle_Recipe.GroupMedicalProgramSPId
      FROM tmpTitle_Recipe
      ORDER BY tmpTitle_Recipe.Id;

     -- начало цикла по курсору1
    LOOP
       -- данные по курсору1
       FETCH curTitle INTO vbId, vbGroupMedicalProgramSPId;

       -- если данные закончились, тогда выход
       IF NOT FOUND THEN EXIT; END IF;
       
       IF COALESCE(vbGroupMedicalProgramSPId, 0) <> 0 
       THEN

         vbQueryText := 'UPDATE tmpResult SET Summa_Recipe' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.Summa_Recipe, 0) 
                                            , Count_Recipe' || COALESCE (vbId, 0)::Text || ' = COALESCE (T1.Count_Recipe, 0) 
                                            , '||vbCount||' = '||vbCount||' + COALESCE (T1.Count_Recipe, 0)
                                            , '||vbTotal||' = '||vbTotal||' + CASE WHEN T1.Count_Recipe > 0 THEN 0 ELSE 0 END
                         FROM (SELECT MI.UnitId 
                                    , ROUND(SUM(MI.Summa), 2) ::TFloat AS Summa_Recipe
                                    , SUM(MI.CountRecipe) ::Integer    AS Count_Recipe
                               FROM tmpMI_Recipe as MI
                               WHERE MI.GroupMedicalProgramSPId = '||COALESCE (vbGroupMedicalProgramSPId, 0)::Text||
                               ' GROUP BY MI.UnitId) AS T1
                         WHERE tmpResult.UnitId = T1.UnitId';
         EXECUTE vbQueryText;
         
       END IF;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curTitle; -- закрыли курсор1    

    -- raise notice 'Value 4: %', CLOCK_TIMESTAMP();

    OPEN Cursor1 FOR
          SELECT tmpTitle.Id
               , tmpTitle.Title
          FROM tmpTitle
          ORDER BY tmpTitle.Id
          ;
    RETURN NEXT Cursor1;
               
    OPEN Cursor2 FOR
          SELECT tmpTitle_Recipe.Id
               , tmpTitle_Recipe.Title1
               , tmpTitle_Recipe.Title2
          FROM tmpTitle_Recipe
          ORDER BY tmpTitle_Recipe.Id
          ;
    RETURN NEXT Cursor2;

    OPEN Cursor3 FOR
          SELECT *
          FROM tmpResult
          ORDER BY tmpResult.JuridicalName, tmpResult.UnitName
          ;
    RETURN NEXT Cursor3;

    -- raise notice 'Value 10: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.03.21                                                       *
*/

-- тест
-- 


select * from gpReport_PaymentHelsi(inStartDate := ('01.05.2023')::TDateTime , inEndDate := ('31.05.2023')::TDateTime ,  inSession := '3');