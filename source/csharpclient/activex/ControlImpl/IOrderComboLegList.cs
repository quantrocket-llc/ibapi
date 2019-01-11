/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true), Guid("39F18DDF-687D-421d-8BB9-4F389D69E428")]
    public interface IOrderComboLegList
    {
        [DispId(-4)]
        object _NewEnum { [return: MarshalAs(UnmanagedType.IUnknown)] get; }
        [DispId(0)]
        object this[int index] { [return: MarshalAs(UnmanagedType.IDispatch)] get; }
        [DispId(1)]
        int Count { get; }
        [DispId(2)]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        object Add();
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComOrderComboLegList : IOrderComboLegList
    {
        private ComList<ComOrderComboLeg, IBApi.OrderComboLeg> Ocl;

        public ComOrderComboLegList() : this(null) { }

        public ComOrderComboLegList(ComList<ComOrderComboLeg, IBApi.OrderComboLeg> ocl)
        {
            this.Ocl = ocl == null ? new ComList<ComOrderComboLeg, IBApi.OrderComboLeg>(new List<IBApi.OrderComboLeg>()) : ocl;
        }

        public object _NewEnum
        {
            get { return Ocl.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return Ocl[index]; }
        }

        public int Count
        {
            get { return Ocl.Count; }
        }

        public object Add()
        {
            var rval = new ComOrderComboLeg();

            Ocl.Add(rval);

            return rval;
        }

        public static implicit operator List<IBApi.OrderComboLeg>(ComOrderComboLegList from)
        {
            return from.Ocl.ConvertTo();
        }
    }
}
