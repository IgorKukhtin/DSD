-- Function:  gpReport_Upload_BaDM()

DROP FUNCTION IF EXISTS gpReport_Upload_BaDM (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_BaDM(
    IN inDate         TDateTime,  -- Операционный день
    IN inObjectId         Integer,    -- Поставщик
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  OperDate      TDateTime, --Дата - дата операционного дня к которой относится произведенная операция 
  JuridicalCode TVarChar,  --Контрагент - код юр.лица в учетной системе БаДМ, к которому относится аптека, предоставляется БаДМ при построении системы
  UnitCode      TVarChar,  --Код склада - код аптеки в учетной системе компании Клиента
  UnitName      TVarChar,  --Наименование склада - наименование аптеки в учетной системе компании Клиента
  GoodsCode     TVarChar,  --Код товара - код товара в учетной системе компании Клиент. Соотнесение кодов товар компаний Клиент и БаДМ осуществляется на стороне компании БаДМ
  GoodsName     TVarChar,  --Наименование товара - наименование товара в учетной системе компании Клиента
  OperCode      Integer,   --Тип операции - код товарной операции в соответствии с таблицей типов операций, которая приведена на листе Типы операций.
                           --Код типа операции  Наименование операции           Единица измерения
                           --1                  Запас товара (на конец дня)	    шт
                           --10	                Продажа товара                  шт
  Amount        TFloat,    --Значение - числовое значение для результата операции. Например, для продажи это кол-во проданных упаковок - 3 шт.
  Segment1      TFloat,    --Сегменты 1-5 - поля для передачи люой дополнительной информации. Если она не используются, то значения должны быть равны 0.
  Segment2      TFloat,
  Segment3      TFloat,
  Segment4      TFloat,
  Segment5      TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectIdRetail Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbObjectIdRetail := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    --Создали таблицу пустографку
    CREATE TEMP TABLE _Cross(
        JuridicalCode TVarChar,
        UnitId        Integer,
        UnitCode      TVarChar,
        GoodsId       Integer,
        GoodsCode     TVarChar,
        GoodsName     TVarChar,
        OperCode      Integer) ON COMMIT DROP;
    --Залили пустографку
    WITH Oper AS (
        Select 1::Integer as OperCode
        UNION
        SELECT 10::Integer AS OperCode
    ),
    Juridical AS(
        Select 
            Object_ImportExportLink.StringKey  AS JuridicalCode
           ,ObjectLink_Unit_Juridical.ObjectId AS UnitId
           ,Object_ImportExportLink_Unit.StringKey AS UnitCode
        FROM Object_ImportExportLink_View AS Object_ImportExportLink
            Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                             AND Object.DescId = zc_Object_Juridical()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                       ON ObjectLink_Unit_Juridical.ChildObjectId = Object.ID
                                      AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT OUTER JOIN Object_ImportExportLink_View AS Object_ImportExportLink_Unit
                                                         ON Object_ImportExportLink_Unit.MainId = ObjectLink_Unit_Juridical.ObjectId
                                                        AND Object_ImportExportLink_Unit.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
                                                        AND Object_ImportExportLink_Unit.ValueId = inObjectId
        WHERE
            Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
            AND
            Object_ImportExportLink.ValueId = inObjectId
            AND
            COALESCE(Object_ImportExportLink_Unit.StringKey,'') <> ''
    ),
    Goods AS(
        SELECT DISTINCT
            LinkGoods_Main_Retail.GoodsId AS GoodsId
           ,Object_Goods_View.GoodsCode   AS GoodsCode
           ,Object_Goods_View.GoodsName   AS GoodsName
        FROM Object_Goods_View
            LEFT JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                            ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- Связь товара поставщика с общим
            LEFT JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- связь товара сети с главным товаром
                                            ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                           AND LinkGoods_Main_Retail.ObjectId = vbObjectIdRetail
        WHERE
            Object_Goods_View.ObjectId = inObjectId
            AND
            Object_Goods_View.IsUpload = TRUE
    )
    INSERT INTO _Cross (JuridicalCode, UnitId, UnitCode, GoodsId, GoodsCode, GoodsName, OperCode)
    SELECT
        Juridical.JuridicalCode
      , Juridical.UnitId
      , Juridical.UnitCode
      , Goods.GoodsId
      , Goods.GoodsCode
      , Goods.GoodsName
      , Oper.OperCode
    FROM 
      Oper
      Cross join Juridical
      Cross Join Goods
    ;
    
    ANALYSE _Cross;
    
    CREATE TEMP TABLE SaleAndRemains ON COMMIT DROP AS(
            SELECT
                10                                       AS OperCode
               ,MovementLinkObject_Unit.ObjectId         AS UnitId
               ,MI_Check.ObjectId                        AS GoodsId
               ,SUM(-MIContainer.Amount)::TFloat         AS Amount
            FROM
                Movement AS Movement_Check
                INNER JOIN MovementItem AS MI_Check
                                        ON MI_Check.MovementId = Movement_Check.Id
                                       AND MI_Check.DescId = zc_MI_Master()
                                       AND MI_Check.isErased = FALSE
                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                INNER JOIN MovementItemContainer AS MIContainer
                                                 ON MIContainer.MovementItemId = MI_Check.Id
                                                AND MIContainer.DescId = zc_MIContainer_Count() 
            WHERE
                Movement_Check.DescId in (zc_Movement_Check(),zc_Movement_Sale())
                AND
                date_trunc('day', Movement_Check.OperDate) = inDate
                AND
                Movement_Check.StatusId = zc_Enum_Status_Complete()
            GROUP BY
                MovementLinkObject_Unit.ObjectId 
               ,MI_Check.ObjectId
            HAVING
               SUM(MIContainer.Amount) <> 0
            UNION ALL   
            SELECT
                1::Integer             AS OperCode
               ,T0.UnitId
               ,T0.GoodsId
               ,SUM(T0.Amount)::TFloat AS Amount
            FROM (
                    SELECT
                        Container.Id
                       ,Container.WhereObjectId AS UnitId
                       ,Container.ObjectId     AS GoodsId
                       ,Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat as Amount
                    FROM
                        Container
                        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                             AND date_trunc('day', MovementItemContainer.OperDate) > inDate
                    WHERE
                        Container.DescId = zc_Container_Count()
                    GROUP BY
                        Container.Id
                       ,Container.WhereObjectId
                       ,Container.ObjectId
                    HAVING
                        (Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat) <> 0
                ) AS T0
            GROUP BY
                T0.UnitId
               ,T0.GoodsId
            HAVING
                COALESCE(SUM(T0.Amount),0) > 0
        );
    
    ANALYSE SaleAndRemains;
     
    -- Результат
    RETURN QUERY
        SELECT
            inDate                                    AS OperDate
           ,_Cross.JuridicalCode
           ,_Cross.UnitCode                           AS UnitCode
           ,Object_Unit.ValueData                     AS UnitName
           ,_Cross.GoodsCode                          AS GoodsCode
           ,_Cross.GoodsName                          AS GoodsName
           ,_Cross.OperCode
           ,SUM(COALESCE(SaleAndRemains.Amount,0))::TFloat AS Amount
           ,0::TFloat                                 AS Segment1
           ,0::TFloat                                 AS Segment2
           ,0::TFloat                                 AS Segment3
           ,0::TFloat                                 AS Segment4
           ,0::TFloat                                 AS Segment5
           
        FROM
            _Cross
            LEFT OUTER JOIN SaleAndRemains ON SaleAndRemains.UnitId = _Cross.UnitId
                                          AND SaleAndRemains.GoodsId = _Cross.GoodsId
                                          AND SaleAndRemains.OperCode = _Cross.OperCode
            LEFT OUTER JOIN Object AS Object_Unit
                                   ON Object_Unit.Id = _Cross.UnitId
        GROUP BY
            _Cross.JuridicalCode
           ,_Cross.UnitCode
           ,Object_Unit.ValueData
           ,_Cross.GoodsCode
           ,_Cross.GoodsName
           ,_Cross.OperCode;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Upload_BaDM (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 23.11.15                                                                       *

*/

-- тест
-- SELECT * FROM gpReport_Upload_BaDM (inDate := '20151101'::TDateTime, inObjectId := 59610, inSession := '3')