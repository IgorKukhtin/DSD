DO $$
DECLARE ioId integer;
BEGIN
   -- Формируем план счетов
   PERFORM lpInsertUpdate_Object(zc_Object_AccountPlan_Foundation(), zc_Object_AccountPlan(), 0, 'Расчеты с учредителями');
   PERFORM lpInsertUpdate_Object(zc_Object_AccountPlan_Cash(), zc_Object_AccountPlan(), 0, 'Касса');

END $$;
