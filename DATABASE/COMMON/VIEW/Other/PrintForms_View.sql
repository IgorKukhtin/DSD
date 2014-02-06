-- View: PrintForms_View

DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS
      SELECT
             zc_movement_sale()                         AS DescId
           , CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --б/н
           , CAST ('PrintMovement_Sale1' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           ,  zc_Enum_PaidKind_SecondForm()             AS PaidKindId --нал
           , CAST ('PrintMovement_Sale2' AS TVarChar)
      UNION

--если с определенной даты появится новая форма добавляем запись, а у предидущей уменьшаем EndDate до StartDate этой записи

-- добавляем записи для покупаетелей с нестандартными формами накладных
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- покупатели с отдельными формами
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale'||OH_JuridicalDetails.OKPO AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199','32516492')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
--налоговая
      SELECT
             zc_movement_sale()
           , CAST ('SaleTax' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('09.02.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax' AS TVarChar)

-- Новая форма налоговой
      UNION
      SELECT
             zc_movement_sale()
           , CAST ('SaleTax' AS TVarChar)
           , CAST ('10.02.2014' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax_2014' AS TVarChar)
-- возвраты стандарт
      UNION
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnIn' AS TVarChar)
       ORDER BY 1,2,4

       ;



ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.02.14                                                        * + ReturnIn
 05.02.14                                                        *
*/

-- тест
-- SELECT * FROM PrintForms_View