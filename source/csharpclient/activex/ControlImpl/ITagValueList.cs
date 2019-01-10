/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Linq;

namespace TWSLib
{
    [ComVisible(true), Guid("CC48E64E-C1A7-4867-8738-578404D75088")]
    public interface ITagValueList
    {
        [DispId(-4)]
        object _NewEnum { [return: MarshalAs(UnmanagedType.IUnknown)] get; }
        [DispId(0)]
        object this[int index] { [return: MarshalAs(UnmanagedType.IDispatch)] get; }
        [DispId(1)]
        int Count { get; }
        [DispId(2)]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        object AddEmpty();
        [DispId(3)]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        object Add(string tag, string value);
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComTagValueList : ITagValueList
    {
        public static implicit operator KeyValuePair<string, string>[](ComTagValueList list)
        {
            return list == null ? null : list.Tvl.Select(x => x.ConvertTo()).Select(x => new KeyValuePair<string, string>(x.Tag, x.Value)).ToArray();
        }

        private ComList<ComTagValue, IBApi.TagValue> Tvl;

        public ComTagValueList() : this(null) { }
        public ComTagValueList(ComList<ComTagValue, IBApi.TagValue> tvl)
        {
            this.Tvl = tvl == null ? new ComList<ComTagValue, IBApi.TagValue>(new List<IBApi.TagValue>()) : tvl;
        }

        public object _NewEnum
        {
            get { return Tvl.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return Tvl[index]; }
        }

        public int Count
        {
            get { return Tvl.Count; }
        }

        public object AddEmpty()
        {
            var rval = new ComTagValue();

            Tvl.Add(rval);

            return rval;
        }

        public object Add(string tag, string value)
        {
            var rval = new ComTagValue(tag, value);

            Tvl.Add(rval);

            return rval;
        }

        public static implicit operator List<IBApi.TagValue>(ComTagValueList from)
        {
            return from.Tvl.ConvertTo();
        }
    }
}
