-- Function:  gpReport_Upload_Teva()

DROP FUNCTION IF EXISTS gpReport_Upload_Teva (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_Teva(
    IN inDate         TDateTime,  -- ������������ ����
    IN inObjectId     Integer,    -- ���������
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate      TDateTime --���� - ���� ������������� ��� � ������� ��������� ������������� �������� 
             , OKPO          TVarChar  --������ ��.����, � �������� ����������� ������
             , UnitName      TVarChar  --������������ ������ - ������������ ������ � ������� ������� �������� �������
             , UnitAddress   TVarChar  --����� ������
             , GoodsName     TVarChar  --������������ ������ - ������������ ������ � ������� ������� �������� �������
             , Amount        TFloat    --�������� - �������� �������� ��� ���������� ��������. ��������, ��� ������� ��� ���-�� ��������� �������� - 3 ��.
             , Summ          TFloat    --����� � ���
             , Price         TFloat    --���� � ���
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

      -- ������ �����
      CREATE TEMP TABLE tmpUnit ON COMMIT DROP
      AS (SELECT ObjectLink_Juridical_Retail.ChildObjectId           AS RetailId
               , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO
               , ObjectLink_Unit_Juridical.ObjectId                  AS UnitId
               , Object_Unit.ValueData                               AS UnitName
               , ObjectString_Unit_Address.ValueData                 AS UnitAddress
          FROM ObjectLink AS ObjectLink_Unit_Juridical
               JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent() 
                              AND ObjectLink_Unit_Parent.ChildObjectId IS NOT NULL
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId
               LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                      ON ObjectString_Unit_Address.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                     AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address() 
               LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails
                                       ON ObjectHistory_JuridicalDetails.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                      AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails() 
                                      AND ObjectHistory_JuridicalDetails.StartDate <= inDate
                                      AND ObjectHistory_JuridicalDetails.EndDate > inDate
               LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                             ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO() 
          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         );

      -- ������ ������� ����������
      CREATE TEMP TABLE tmpGoods ON COMMIT DROP
      AS (SELECT DISTINCT LinkGoods_Main_Retail.GoodsId AS GoodsId
                        , Object_Goods_View.GoodsName   AS GoodsName
          FROM Object_Goods_View
               JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                          ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- ����� ������ ���������� � �����
               JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- ����� ������ ���� � ������� �������
                                          ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
               JOIN Object AS Object_Retail
                           ON Object_Retail.Id = LinkGoods_Main_Retail.ObjectId
                          AND Object_Retail.DescId = zc_Object_Retail() 
          WHERE Object_Goods_View.ObjectId = inObjectId
         ); 

      -- ������� �� ��������� ����
      CREATE TEMP TABLE tmpSales ON COMMIT DROP
      AS (SELECT DATE_TRUNC ('day', Movement_Check.OperDate)::TDateTime AS OperDate
               , MovementLinkObject_Unit.ObjectId                       AS UnitId
               , MI_Check.ObjectId                                      AS GoodsId
               , COALESCE (MIFloat_Price.ValueData, 0.0)::TFloat        AS Price
               , SUM (MI_Check.Amount)::TFloat                          AS Amount
               , SUM (COALESCE (MIFloat_Price.ValueData, 0.0) * MI_Check.Amount)::TFloat AS Summ
          FROM Movement AS Movement_Check
               JOIN MovementItem AS MI_Check
                                 ON MI_Check.MovementId = Movement_Check.Id
                                AND MI_Check.DescId = zc_MI_Master()
                                AND MI_Check.isErased = FALSE
               JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MI_Check.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price() 
          WHERE Movement_Check.DescId IN (zc_Movement_Check(), zc_Movement_Sale())
            AND DATE_TRUNC ('day', Movement_Check.OperDate)::TDateTime = inDate 
            AND Movement_Check.StatusId = zc_Enum_Status_Complete()
          GROUP BY DATE_TRUNC ('day', Movement_Check.OperDate)
                 , MovementLinkObject_Unit.ObjectId
                 , MI_Check.ObjectId
                 , MIFloat_Price.ValueData
         );

      -- ���������
      RETURN QUERY
        SELECT tmpSales.OperDate
             , tmpUnit.OKPO
             , tmpUnit.UnitName
             , tmpUnit.UnitAddress
             , tmpGoods.GoodsName
             , tmpSales.Amount
             , tmpSales.Summ
             , tmpSales.Price   
        FROM tmpSales
             JOIN tmpUnit ON tmpUnit.UnitId = tmpSales.UnitId
             JOIN tmpGoods ON tmpGoods.GoodsId = tmpSales.GoodsId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  �������� �.�.
 29.03.17                                                                         *

*/

-- ����
-- SELECT * FROM gpReport_Upload_Teva (inDate:= '07.02.2017'::TDateTime, inObjectId:= 59610, inSession:= zfCalc_UserAdmin())
