//+------------------------------------------------------------------+
//|                                                    StopsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "StopBase.mqh"
class CExpertAdvisor;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopsBase : public CArrayObj
  {
protected:
   bool              m_active;
   CObject          *m_container;
public:
                     CStopsBase(void);
                    ~CStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOPS;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*);
   virtual void      SetContainer(CObject *container){m_container=container;}
   virtual bool      Validate(void) const;
   //--- setters and getters
   virtual bool      Active(void) const {return m_active;}
   virtual void      Active(const bool activate) {m_active=activate;}
   virtual CStop    *Main(void);
   //--- recovery
   virtual bool      CreateElement(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopsBase::CStopsBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopsBase::~CStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if (stop!=NULL)
         if (!stop.Init(symbolmanager,accountinfo))
            return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(!stop.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop *CStopsBase::Main()
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(stop.Main()) return stop;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::CreateElement(const int index)
  {
   CStop * stop = new CStop();
   stop.SetContainer(GetPointer(this));
   return Insert(GetPointer(stop),index);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Stop\Stops.mqh"
#else
#include "..\..\MQL4\Stop\Stops.mqh"
#endif
//+------------------------------------------------------------------+
