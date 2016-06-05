//+------------------------------------------------------------------+
//|                                               OrderStopsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "OrderStopBase.mqh"
class JOrder;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStopsBase : public CArrayObj
  {
protected:
   JOrder           *m_order;
public:
                     JOrderStopsBase(void);
                    ~JOrderStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOPS;}
   //--- initialization
   virtual void      SetContainer(JOrder *order){m_order=order;}
   virtual bool      NewOrderStop(JOrder *order,JStop *stop,JOrderStops *order_stops);
   //--- checking
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(JOrderStop *orderstop) {return true;}
   virtual bool      Close(void);
   //--- hiding and showing of stop lines
   virtual void      Show(bool show=true);
   //--- recovery
   virtual bool      CreateElement(const int index);
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::JOrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::~JOrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::NewOrderStop(JOrder *order,JStop *stop,JOrderStops *order_stops)
  {
   JOrderStop *order_stop=new JOrderStop();
   order_stop.Init(order,stop,order_stops);
   return Add(order_stop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Check(double &volume)
  {
   int total=Total();
   if(total>0)
     {
      for(int i=0;i<Total();i++)
        {
         JOrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            order_stop.CheckTrailing();
            order_stop.Update();
            order_stop.Check(volume);
            if(!CheckNewTicket(order_stop)) return;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Close(void)
  {
   bool res=true;
   int total=Total();
   if(total>0)
     {
      for(int i=0;i<total;i++)
        {
         JOrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            if(!order_stop.Close())
               res=false;
           }
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Show(bool show=true)
  {
   for (int i=0;i<Total();i++)
   {
      JOrderStop *orderstop = At(i);
      orderstop.Show(show);
   }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::CreateElement(const int index)
  {
   JOrderStop * orderstop = new JOrderStop();
   orderstop.SetContainer(GetPointer(this));
   return Insert(GetPointer(orderstop),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Save(const int handle)
  {  
   CArrayObj::Save(handle);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStops.mqh"
#else
#include "..\..\mql4\order\OrderStops.mqh"
#endif
//+------------------------------------------------------------------+
