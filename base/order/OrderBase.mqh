//+------------------------------------------------------------------+
//|                                                        JOrderBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "..\event\EventBase.mqh"
#include "OrderStopsBase.mqh"
class JOrders;
class JStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderBase : public CObject
  {
protected:
   bool              m_activate;
   bool              m_closed;
   int               m_magic;
   double            m_price;
   ulong             m_ticket;
   ENUM_ORDER_TYPE   m_type;
   double            m_volume;
   double            m_volume_initial;
   JOrderStops       m_order_stops;
   JOrderStop       *m_main_stop;
   JOrders          *m_orders;
public:
                     JOrderBase();
                    ~JOrderBase();
   //--- initialization
   virtual void      SetContainer(JOrders *orders){m_orders=orders;}                    
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- order functions                    
   virtual void      CreateStops(JStops *stops);
   virtual void      CheckStops();
   virtual void      IsClosed(bool closed) {m_closed=closed;}
   virtual bool      IsClosed() {return(false);}
   virtual void      Magic(int magic){m_magic=magic;}
   virtual int       Magic(){return(m_magic);}
   virtual void      Price(double price){m_price=price;}
   virtual double    Price(){return(m_price);}
   virtual void      OrderType(ENUM_ORDER_TYPE type){m_type=type;}
   virtual ENUM_ORDER_TYPE OrderType(){return(m_type);}
   virtual void      Ticket(ulong ticket) {m_ticket=ticket;}
   virtual ulong     Ticket() {return(m_ticket);}
   virtual int       Type() {return(CLASS_TYPE_ORDER);}
   virtual void      Volume(double volume){m_volume=volume;}
   virtual double    Volume(){return(m_volume);}
   virtual void      VolumeInitial(double volume){m_volume_initial=volume;}
   virtual double    VolumeInitial(){return(m_volume_initial);}
   //--- archiving
   virtual bool      CloseStops();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderBase::JOrderBase() : m_activate(true),
                           m_closed(false),
                           m_magic(0),
                           m_price(0.0),
                           m_ticket(0),
                           m_type(0),
                           m_volume(0.0),
                           m_volume_initial(0.0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderBase::~JOrderBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateStops(JStops *stops)
  {
   int total= stops.Total();
   for(int i=0;i<total;i++)
     {
      JStop *stop=stops.At(i);
      if(!CheckPointer(stop)) continue;
      JOrderStop *order_stop=new JOrderStop();
      order_stop.Init(GetPointer(this),stop);
      order_stop.SetContainer(GetPointer(m_order_stops));
      if(stop.Main())
         m_main_stop=order_stop;
      m_order_stops.Add(order_stop);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CheckStops()
  {
   m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::CloseStops()
  {
   return(m_order_stops.Close());
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\Order.mqh"
#else
#include "..\..\mql4\order\Order.mqh"
#endif
//+------------------------------------------------------------------+