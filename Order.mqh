//+------------------------------------------------------------------+
//|                                                        JOrder.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Arrays\ArrayObj.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrder : public CObject
  {
private:
protected:
   ulong             m_order_ticket;
   ENUM_ORDER_TYPE   m_order_type;
   double            m_order_volume;
   double            m_order_price;
public:
                     JOrder();
                     JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price);
                    ~JOrder();
   virtual ENUM_ORDER_TYPE OrderType() {return(m_order_type);}
   virtual ulong OrderTicket() {return(m_order_ticket);}
   virtual double OrderVolume(){return(m_order_volume);}
   virtual double OrderPrice(){return(m_order_price);}
   virtual void OrderType(ulong ticket) {m_order_ticket = ticket;}
   virtual void OrderTicket(ENUM_ORDER_TYPE type){m_order_type = type;}
   virtual void OrderVolume(double volume){m_order_volume = volume;}
   virtual void OrderPrice(double price){m_order_price = price;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder()
  {
  }
  
JOrder::JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price)
  {
   m_order_ticket = ticket;
   m_order_type = type;
   m_order_volume = volume;
   m_order_price = price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::~JOrder()
  {
  }
//+------------------------------------------------------------------+
