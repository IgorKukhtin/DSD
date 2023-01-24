-- Function:  gpReport_Upload_Optima()

DROP FUNCTION IF EXISTS gpReport_Upload_Optima (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_Optima(
    IN inDate         TDateTime,  -- Операционный день
    IN inObjectId     Integer,    -- Поставщик
    IN inUnitId       Integer,    -- Торговая точка
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)

-- RETURNS TABLE (
  -- OperDate      TDateTime, --Дата - дата операционного дня к которой относится произведенная операция 
  -- JuridicalCode TVarChar,  --Контрагент - код юр.лица в учетной системе БаДМ, к которому относится аптека, предоставляется БаДМ при построении системы
  -- UnitCode      Integer,   --Код склада - код аптеки в учетной системе компании Клиента
  -- UnitName      TVarChar,  --Наименование склада - наименование аптеки в учетной системе компании Клиента
  -- GoodsCode     Integer,   --Код товара - код товара в учетной системе компании Клиент. Соотнесение кодов товар компаний Клиент и БаДМ осуществляется на стороне компании БаДМ
  -- GoodsName     TVarChar,  --Наименование товара - наименование товара в учетной системе компании Клиента
  -- OperCode      Integer,   --Тип операции - код товарной операции в соответствии с таблицей типов операций, которая приведена на листе Типы операций.
                           -- --Код типа операции  Наименование операции           Единица измерения
                           -- --1                  Запас товара (на конец дня)	    шт
                           -- --10	                Продажа товара                  шт
  -- Amount        TFloat,    --Значение - числовое значение для результата операции. Например, для продажи это кол-во проданных упаковок - 3 шт.
  -- Segment1      TFloat,    --Сегменты 1-5 - поля для передачи люой дополнительной информации. Если она не используются, то значения должны быть равны 0.
  -- Segment2      TFloat,
  -- Segment3      TFloat,
  -- Segment4      TFloat,
  -- Segment5      TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectIdRetail Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbObjectOKPO TVarChar;   
 
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!только НЕ так определяется <Торговая сеть>!!!
    -- vbObjectIdRetail := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    -- !!!только так - определяется <Торговая сеть>!!!
    vbObjectIdRetail:= COALESCE (
                       (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                             INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                          AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       ), lpGet_DefaultValue ('zc_Object_Retail', vbUserId) :: Integer);



    --Юрлицо торговой точки
    SELECT
        ObjectLink.ChildObjectId
    INTO
        vbJuridicalId
    FROM
        ObjectLink
    WHERE
        ObjectLink.ObjectId = inUnitId
        AND
        ObjectLink.DescId = zc_ObjectLink_Unit_Juridical();
    --ОКПО поставщика
    SELECT
        JuridicalDetails.OKPO
    INTO
        vbObjectOKPO
    FROM 
        gpGet_ObjectHistory_JuridicalDetails(inObjectId,inDate,inSession) AS JuridicalDetails;
    --Создали таблицу для результата
    CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
    
    --Шапка
    INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="windows-1251" standalone="yes"?>');
    INSERT INTO _Result(RowData) Values ('<PReport xmlns="http://tempuri.org/PReport.xsd">');
    INSERT INTO _Result(RowData) Values ('<Header>');
    INSERT INTO _Result(RowData) Values ('<Report_Type>pr001</Report_Type>');
    INSERT INTO _Result(RowData) Values ('<Report_Version>1.3</Report_Version>');
    INSERT INTO _Result(RowData) Values ('<Debtor_Code>'||COALESCE((Select Object_ImportExportLink.StringKey  AS DebtorCode
                                                           FROM Object_ImportExportLink_View AS Object_ImportExportLink
                                                               Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                                                                                AND Object.DescId = zc_Object_Juridical()
                                                               
                                                           WHERE
                                                               Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
                                                               AND
                                                               Object_ImportExportLink.ValueId = inObjectId
                                                               AND
                                                               Object_ImportExportLink.MainId = vbJuridicalId
                                                               ),'')||'</Debtor_Code>');
    INSERT INTO _Result(RowData) Values ('<OKPO>'||COALESCE((SELECT JuridicalDetails.OKPO
                                                    FROM gpGet_ObjectHistory_JuridicalDetails(vbJuridicalId,inDate,inSession) AS JuridicalDetails),'')||'</OKPO>');
    INSERT INTO _Result(RowData) Values ('<Delivery_Code>'||COALESCE((Select Object_ImportExportLink.StringKey AS DeliveryCode
                                                             FROM Object_ImportExportLink_View AS Object_ImportExportLink
                                                                 Inner Join Object ON Object_ImportExportLink.MainId = Object.ID
                                                                                  AND Object.DescId = zc_Object_Unit()
                                                             WHERE
                                                                 Object_ImportExportLink.LinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance()
                                                                 AND
                                                                 Object_ImportExportLink.ValueId = inObjectId
                                                                 AND
                                                                 Object_ImportExportLink.MainId = inUnitId),'')||'</Delivery_Code>');
    INSERT INTO _Result(RowData) Values ('<Post_Code></Post_Code>');
    INSERT INTO _Result(RowData) Values ('<Report_Date>'||to_char(inDate,'YYYY-MM-DD')||'T00:00:00</Report_Date>');
    INSERT INTO _Result(RowData) Values ('<Create_Date>'||to_char(CURRENT_TIMESTAMP,'YYYY-MM-DD')||'T00:00:00</Create_Date>');
    INSERT INTO _Result(RowData) Values ('</Header>');
  
    -- Создали таблицу пустографку
    CREATE TEMP TABLE _Cross(
        GoodsId         Integer,
        GoodsCode       TVarChar,
        GoodsName       TVarChar) ON COMMIT DROP;
    -- Залили пустографку
    WITH Goods AS(
        SELECT DISTINCT
            LinkGoods_Main_Retail.GoodsId AS GoodsId,
            Object_Goods_View.GoodsCode
        FROM Object_Goods_View
            LEFT OUTER JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                  ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- Связь товара поставщика с общим
            LEFT OUTER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- связь товара сети с главным товаром
                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                                 AND LinkGoods_Main_Retail.ObjectId = vbObjectIdRetail
        WHERE Object_Goods_View.ObjectId = inObjectId
          AND Object_Goods_View.IsUpload = TRUE
       )
    INSERT INTO _Cross (GoodsId,GoodsCode)
      SELECT Goods.GoodsId, Goods.GoodsCode FROM  Goods;
    
    ANALYSE _Cross;

    -- Остатки
    WITH Remains AS(
        SELECT T0.GoodsId
             , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
             , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
             , SUM (T0.Amount) :: TFloat AS Amount
        FROM (SELECT
                    Container.Id
                   ,Container.ObjectId        AS GoodsId
                   ,Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat as Amount
              FROM
                    Container
                    LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ID
                                                         AND date_trunc('day', MovementItemContainer.OperDate) > inDate
                    INNER JOIN containerlinkobject AS ContainerLinkObject_MovementItem 
                                                   ON ContainerLinkObject_MovementItem.containerid = Container.Id
                                                  AND ContainerLinkObject_MovementItem.descid = zc_ContainerLinkObject_PartionMovementItem()
                    INNER JOIN OBJECT AS Object_PartionMovementItem 
                                      ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                    INNER JOIN MovementItem AS MI_Income
                                            ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Income_From
                                                  ON MovementLinkObject_Income_From.MovementId = MI_Income.MovementId
                                                 AND MovementLinkObject_Income_From.DescId = zc_MovementLinkObject_From()
                                                 AND MovementLinkObject_Income_From.ObjectId = inObjectId
              WHERE Container.DescId = zc_Container_Count()
                AND Container.WhereObjectId = inUnitId
              GROUP BY Container.Id
                     , Container.ObjectId
              HAVING (Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0.0)::TFloat) <> 0
            ) AS T0
                                    -- партия
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = T0.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    -- элемент прихода
                                    LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемент прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

        GROUP BY T0.GoodsId
               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
               , COALESCE (MI_Income_find.Id,         MI_Income.Id)
        HAVING COALESCE (SUM (T0.Amount), 0) > 0
       )
    INSERT INTO _Result (RowData)
    SELECT
        '<Remains>'
     || '<Supplier_Code>' || vbObjectOKPO || '</Supplier_Code>'
     || '<Item_Code_Optima>' || _Cross.GoodsCode ||'</Item_Code_Optima>'
     || '<Item_Code_Morion></Item_Code_Morion>'
     || '<Item_Code_Supplier>' || _Cross.GoodsCode || '</Item_Code_Supplier>'
     || '<Document_Number>' || COALESCE (Movement.InvNumber, '') || '</Document_Number>'
     || '<Batch_Number>' || COALESCE (MIString_PartionGoods.ValueData, '') || '</Batch_Number>'
     || '<Price_In></Price_In>'
     || '<Remains>' || COALESCE (Remains.Amount, 0) :: TVarChar || '</Remains>'
     || '</Remains>'
    FROM _Cross
         LEFT JOIN Remains ON _Cross.GoodsId = Remains.GoodsId
         LEFT JOIN Movement ON Movement.Id = Remains.MovementId
         LEFT JOIN MovementItemString AS MIString_PartionGoods
                                      ON MIString_PartionGoods.MovementItemId = Remains.MovementItemId
                                     AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
   ;
   
   ANALYSE _Result;
 
    -- Продажи
    WITH Sale AS(
        SELECT
            MI_Check.ObjectId                        AS GoodsId
          , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
          , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
          , SUM (-1 * MIContainer.Amount)  :: TFloat AS Amount
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
            INNER JOIN containerlinkobject AS ContainerLinkObject_MovementItem 
                                           ON ContainerLinkObject_MovementItem.containerid = MIContainer.ContainerId
                                          AND ContainerLinkObject_MovementItem.descid = zc_ContainerLinkObject_PartionMovementItem()
            INNER JOIN OBJECT AS Object_PartionMovementItem 
                              ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
            INNER JOIN MovementItem AS MI_Income
                                    ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- элемент прихода от поставщика (если это партия, которая была создана инвентаризацией)
            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

            INNER JOIN MovementLinkObject AS MovementLinkObject_Income_From
                                          ON MovementLinkObject_Income_From.MovementId = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                         AND MovementLinkObject_Income_From.DescId = zc_MovementLinkObject_From()
                                         AND MovementLinkObject_Income_From.ObjectId = inObjectId
                                         
        WHERE
            Movement_Check.DescId in (zc_Movement_Check(),zc_Movement_Sale())
            AND
            date_trunc('day', Movement_Check.OperDate) = inDate
            AND
            Movement_Check.StatusId = zc_Enum_Status_Complete()
            AND
            MovementLinkObject_Unit.ObjectId = inUnitId
        GROUP BY
            MI_Check.ObjectId
          , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
          , COALESCE (MI_Income_find.Id,         MI_Income.Id)
        HAVING SUM (MIContainer.Amount) <> 0
    )
    INSERT INTO _Result (RowData)
    SELECT
        '<Sales><Supplier_Code>'||vbObjectOKPO||'</Supplier_Code>'
     || '<Item_Code_Optima>'||_Cross.GoodsCode||'</Item_Code_Optima>'
     || '<Item_Code_Morion></Item_Code_Morion>'
     || '<Item_Code_Supplier>'||_Cross.GoodsCode||'</Item_Code_Supplier>'
     || '<Document_Number>' || COALESCE (Movement.InvNumber, '') || '</Document_Number>'
     || '<Batch_Number>' || COALESCE (MIString_PartionGoods.ValueData, '') || '</Batch_Number>'
     || '<Price_In></Price_In>'
     || '<Price_Out></Price_Out>'
     || '<Check_Code></Check_Code>'
     || '<Check_Time></Check_Time>'
     || '<Card_Id></Card_Id>'
     || '<Sales>'||COALESCE(Sale.Amount,0)::TVarChar||'</Sales>'
     || '</Sales>'

    FROM _Cross
         LEFT OUTER JOIN Sale ON Sale.GoodsId = _Cross.GoodsId
         LEFT JOIN Movement ON Movement.Id = Sale.MovementId
         LEFT JOIN MovementItemString AS MIString_PartionGoods
                                      ON MIString_PartionGoods.MovementItemId = Sale.MovementItemId
                                     AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
        ;
    INSERT INTO _Result (RowData) Values ('</PReport>');

    ANALYSE _Result;
    
    -- РЕЗУЛЬТАТ
    RETURN QUERY
        SELECT _Result.RowData from _Result;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Upload_Optima (TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.07.16                                        *
 23.11.15                                                                       *
*/

-- тест
-- SELECT * FROM gpReport_Upload_Optima (inDate:= '17.10.2016', inObjectId := 59611, inUnitId := 183293, inSession := '3') -- "Аптека_2 ул_Петрова комбрига_6"
-- SELECT * FROM gpReport_Upload_Optima (inDate:= '17.10.2016', inObjectId := 59611, inUnitId := 2144918, inSession := '3') -- "Аптека_Никополь"
