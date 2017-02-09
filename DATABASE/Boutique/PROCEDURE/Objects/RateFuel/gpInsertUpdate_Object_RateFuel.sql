-- Function: gpInsertUpdate_Object_RateFuel (nteger, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RateFuel (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RateFuel(
 INOUT ioId                             Integer   ,    -- ���� ������� <������>
    IN inRateFuelId_Internal            Integer   ,    -- ���� ����� ������� �����
    IN inRateFuelId_External            Integer   ,    -- ���� ����� ������� ��������
    IN inAmount_Internal                TFloat    ,    -- ���-�� ����� �� 100 ��
    IN inAmountColdHour_Internal        TFloat    ,    -- �����, ���-�� ����� � ���
    IN inAmountColdDistance_Internal    TFloat    ,    -- �����, ���-�� ����� �� 100 ��
    IN inAmount_External                TFloat    ,    -- ���-�� ����� �� 100 ��
    IN inAmountColdHour_External        TFloat    ,    -- �����, ���-�� ����� � ���
    IN inAmountColdDistance_External    TFloat    ,    -- �����, ���-�� ����� �� 100 ��
    IN inSession                        TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RateFuel());
       
   -- 
   SELECT tmpRateFuel.RateFuelId_Internal  AS RateFuelId_Internal
        , tmpRateFuel.RateFuelId_External  AS RateFuelId_External
          INTO inRateFuelId_Internal, inRateFuelId_External
   FROM Object AS Object_Car
            JOIN ( SELECT ObjectLink_RateFuel_Car.ChildObjectId AS CarId
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_Internal() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_Internal
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_External() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_External
                   FROM Object AS Object_RateFuel
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_Car
                                                  ON ObjectLink_RateFuel_Car.ObjectId = Object_RateFuel.Id
                                                 AND ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = Object_RateFuel.Id
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                  WHERE Object_RateFuel.DescId = zc_Object_RateFuel()
                  GROUP BY ObjectLink_RateFuel_Car.ChildObjectId
                 ) AS tmpRateFuel ON tmpRateFuel.CarId = Object_Car.Id
   WHERE  Object_Car.Id = ioId ;
                             
   -- ��������� <������>
   inRateFuelId_External := lpInsertUpdate_Object(inRateFuelId_External, zc_Object_RateFuel(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_Amount(), inRateFuelId_External, inAmount_External);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountColdHour(), inRateFuelId_External, inAmountColdHour_External);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountColdDistance(), inRateFuelId_External, inAmountColdDistance_External);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_Car(), inRateFuelId_External, ioId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RouteKind(), inRateFuelId_External, zc_Enum_RouteKind_External());



   inRateFuelId_Internal := lpInsertUpdate_Object(inRateFuelId_Internal, zc_Object_RateFuel(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_Amount(), inRateFuelId_Internal, inAmount_Internal);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountColdHour(), inRateFuelId_Internal, inAmountColdHour_Internal);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountColdDistance(), inRateFuelId_Internal, inAmountColdDistance_Internal);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_Car(), inRateFuelId_Internal, ioId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RouteKind(), inRateFuelId_Internal, zc_Enum_RouteKind_Internal());

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_RateFuel (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.12.13                                        * add vbUserId
 29.09.13                                        * 
 24.09.13          * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RateFuel()
