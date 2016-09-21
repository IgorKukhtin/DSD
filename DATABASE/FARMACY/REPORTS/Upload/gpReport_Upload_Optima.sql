-- Function:  gpReport_Upload_Optima()

DROP FUNCTION IF EXISTS gpReport_Upload_Optima (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_Optima(
    IN inDate         TDateTime,  -- ������������ ����
    IN inObjectId     Integer,    -- ���������
    IN inUnitId       Integer,    -- �������� �����
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)

-- RETURNS TABLE (
  -- OperDate      TDateTime, --���� - ���� ������������� ��� � ������� ��������� ������������� �������� 
  -- JuridicalCode TVarChar,  --���������� - ��� ��.���� � ������� ������� ����, � �������� ��������� ������, ��������������� ���� ��� ���������� �������
  -- UnitCode      Integer,   --��� ������ - ��� ������ � ������� ������� �������� �������
  -- UnitName      TVarChar,  --������������ ������ - ������������ ������ � ������� ������� �������� �������
  -- GoodsCode     Integer,   --��� ������ - ��� ������ � ������� ������� �������� ������. ����������� ����� ����� �������� ������ � ���� �������������� �� ������� �������� ����
  -- GoodsName     TVarChar,  --������������ ������ - ������������ ������ � ������� ������� �������� �������
  -- OperCode      Integer,   --��� �������� - ��� �������� �������� � ������������ � �������� ����� ��������, ������� ��������� �� ����� ���� ��������.
                           -- --��� ���� ��������  ������������ ��������           ������� ���������
                           -- --1                  ����� ������ (�� ����� ���)	    ��
                           -- --10	                ������� ������                  ��
  -- Amount        TFloat,    --�������� - �������� �������� ��� ���������� ��������. ��������, ��� ������� ��� ���-�� ��������� �������� - 3 ��.
  -- Segment1      TFloat,    --�������� 1-5 - ���� ��� �������� ���� �������������� ����������. ���� ��� �� ������������, �� �������� ������ ���� ����� 0.
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

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbObjectIdRetail := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    --������ �������� �����
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
    --���� ����������
    SELECT
        JuridicalDetails.OKPO
    INTO
        vbObjectOKPO
    FROM 
        gpGet_ObjectHistory_JuridicalDetails(inObjectId,inDate,inSession) AS JuridicalDetails;
    --������� ������� ��� ����������
    CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
    
    --�����
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
  
    -- ������� ������� �����������
    CREATE TEMP TABLE _Cross(
        GoodsId         Integer,
        GoodsCode       TVarChar,
        GoodsName       TVarChar) ON COMMIT DROP;
    -- ������ �����������
    WITH Goods AS(
        SELECT DISTINCT
            LinkGoods_Main_Retail.GoodsId AS GoodsId,
            Object_Goods_View.GoodsCode
        FROM Object_Goods_View
            LEFT OUTER JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                                  ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- ����� ������ ���������� � �����
            LEFT OUTER JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- ����� ������ ���� � ������� �������
                                                  ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
                                                 AND LinkGoods_Main_Retail.ObjectId = vbObjectIdRetail
        WHERE Object_Goods_View.ObjectId = inObjectId
          AND Object_Goods_View.IsUpload = TRUE
       )
    INSERT INTO _Cross (GoodsId,GoodsCode)
      SELECT Goods.GoodsId, Goods.GoodsCode FROM  Goods;
    

    -- �������
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
                                    -- ������
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                        ON CLI_MI.ContainerId = T0.Id
                                                                       AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    -- ������� �������
                                    LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- ������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
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
 
    -- �������
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
            -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- ������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
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

    -- ���������
    RETURN QUERY
        SELECT _Result.RowData from _Result;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Upload_Optima (TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 08.07.16                                        *
 23.11.15                                                                       *
*/

-- ����
-- SELECT * FROM gpReport_Upload_Optima (inDate:= '19.09.2016', inObjectId := 59611, inUnitId := 183293, inSession := '3')
