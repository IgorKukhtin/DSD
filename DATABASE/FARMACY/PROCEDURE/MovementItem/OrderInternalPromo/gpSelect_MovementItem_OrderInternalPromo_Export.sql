-- Function: gpSelect_MovementItem_OrderInternalPromo_Export()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternalPromo_Export (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternalPromo_Export(
    IN inMovementId  Integer      , -- ���� ���������
    IN inJuridicalId Integer      , -- ���������
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS SETOF refcursor 

AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;

  DECLARE vbQueryText   Text;
  DECLARE curUnit refcursor;
  DECLARE vbUnitId Integer;
  DECLARE vbIndex Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

/*     SELECT Movement_OrderExternal_View.FromId
          , ObjectHistory_JuridicalDetails.OKPO -- ������ ��.����
          , Movement_OrderExternal_View.ToCode
   INTO vbJuridicalId, vbOKPO, vbUnitCode
     FROM Movement_OrderExternal_View
          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Movement_OrderExternal_View.JuridicalId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
     WHERE Movement_OrderExternal_View.Id = inMovementId;
*/

     -- �������� ��� ������������ �� ����������
     
     CREATE TEMP TABLE tmpOrderInternal ON COMMIT DROP AS
     SELECT Id, GoodsId, GoodsName, GoodsCode, JuridicalName, Price
     FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
     WHERE T1.JuridicalId = inJuridicalId
       AND T1.Amount > 0;

     IF NOT EXISTS(SELECT * FROM tmpOrderInternal)
     THEN
         RAISE EXCEPTION '��� ������ ��� ��������.';
     END IF;


     -- �������� ��� ������������ �� ���������� �� �������

     CREATE TEMP TABLE tmpOrderInternalChild ON COMMIT DROP AS
     SELECT tmpOrderInternal.GoodsId
          ,  MovementItem.ObjectId AS UnitId
          ,  MovementItem.Amount
     
     FROM tmpOrderInternal 
          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.isErased = FALSE
                                 AND MovementItem.ParentId = tmpOrderInternal.Id
                                 AND MovementItem.Amount > 0;
                                 
     -- ����������� �������������
     CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
     SELECT DISTINCT tmpOrderInternalChild.UnitId
     FROM tmpOrderInternalChild 
     ORDER BY 1;
                                 
     -- ��������� �������
     vbIndex := 1;
     OPEN curUnit FOR
     SELECT tmpUnit.UnitId
     FROM tmpUnit 
     ORDER BY tmpUnit.UnitId;

     -- ������ ����� �� �������1
     LOOP
        -- ������ �� �������1
        FETCH curUnit INTO vbUnitId;
        -- ���� ������ �����������, ����� �����
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpOrderInternal ADD COLUMN Amount' || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpOrderInternal SET Amount' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.Amount, 0) ' ||
                       ' FROM (SELECT tmpOrderInternalChild.GoodsId, SUM(tmpOrderInternalChild.Amount) AS Amount 
                               FROM tmpOrderInternalChild WHERE tmpOrderInternalChild.UnitId = '|| vbUnitId::Text ||' GROUP BY tmpOrderInternalChild.GoodsId) AS T1'||
                       ' WHERE tmpOrderInternal.GoodsId = T1.GoodsId';
        EXECUTE vbQueryText;

        vbIndex := vbIndex + 1;
     END LOOP; -- ����� ����� �� �������1
     CLOSE curUnit; -- ������� ������1
     
     --raise notice 'Value 03: %', (SELECT count(*) FROM tmpOrderInternalChild);

     OPEN Cursor1 FOR
     SELECT 'GoodsName'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'GoodsCode'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'JuridicalName'::TVarChar AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT 'Price'::TVarChar  AS FieldName
          , ' '::TVarChar AS DisplayName
          , 100 AS Width 
     UNION ALL
     SELECT ('Amount'||(ROW_NUMBER()OVER(ORDER BY tmpUnit.UnitId))::TVarChar)::TVarChar  AS FieldName
          , (Object_Unit.ValueData||' ('||Object_Juridical.ValueData||' '||
            COALESCE(ObjectHistory_JuridicalDetails.OKPO, '')||')')::TVarChar AS DisplayName
          , 100 AS Width 
     FROM tmpUnit 
     
          LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = tmpUnit.UnitId
          
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId
                              
          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_Unit_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
          
     ;

     RETURN NEXT Cursor1;
     
     ALTER TABLE tmpOrderInternal DROP COLUMN Id;
     
     ALTER TABLE tmpOrderInternal DROP COLUMN GoodsId;

     OPEN Cursor2 FOR
     SELECT *
     FROM tmpOrderInternal;

     RETURN NEXT Cursor2;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternalPromo_Export (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.08.21                                                       *

*/

-- ����
-- 
select * from gpSelect_MovementItem_OrderInternalPromo_Export(inMovementId := 23631157 , inJuridicalId := 59611 , inSession := '3');