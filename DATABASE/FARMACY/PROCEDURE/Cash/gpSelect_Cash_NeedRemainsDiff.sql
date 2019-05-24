-- Function: gpSelect_Cash_NeedRemainsDiff()

--DROP FUNCTION IF EXISTS gpSelect_Cash_NeedRemainsDiff (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Cash_NeedRemainsDiff (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_NeedRemainsDiff (
    IN inCashSessionId  TVarChar,      -- ������ ��������� �����
   OUT outIsRemainsDiff Boolean,       -- ���� ��������
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbLastRemainsDiff TDateTime;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');

   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   outIsRemainsDiff := False;

   IF EXISTS(SELECT * FROM CashSession WHERE Id = inCashSessionId)
   THEN
     SELECT LastConnect INTO vbLastRemainsDiff
     FROM CashSession WHERE Id = inCashSessionId;
   ELSE
     RETURN;
   END IF;

   IF vbLastRemainsDiff + INTERVAL '2 MIN' > CURRENT_TIMESTAMP
   THEN
     RETURN;
   END IF;
   

   IF EXISTS(SELECT * FROM MovementItemContainer
             WHERE OperDate > vbLastRemainsDiff
             AND WhereObjectId_Analyzer = vbUnitId)
   THEN
     outIsRemainsDiff := True;
   END IF;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.05.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Cash_NeedRemainsDiff('{0B05C610-B172-4F81-99B8-25BF5385ADD6}', '3')