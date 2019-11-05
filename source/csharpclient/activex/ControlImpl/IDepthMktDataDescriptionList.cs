/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), Guid("809BA84D-2412-4015-BC0E-B3A1175BFB9A")]
    public interface IDepthMktDataDescriptionList
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
    public class ComDepthMktDataDescriptionList : IDepthMktDataDescriptionList
    {
        private ComList<ComDepthMktDataDescription, IBApi.DepthMktDataDescription> DepthMktDataDescriptionList;

        public ComDepthMktDataDescriptionList() : this(null) { }

        public ComDepthMktDataDescriptionList(DepthMktDataDescription[] depthMktDataDescriptions)
        {
            this.DepthMktDataDescriptionList = (depthMktDataDescriptions.Length > 0) ? new ComList<ComDepthMktDataDescription, IBApi.DepthMktDataDescription>(new List<IBApi.DepthMktDataDescription>(depthMktDataDescriptions)) : null;
        }

        public object _NewEnum
        {
            get { return DepthMktDataDescriptionList.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return DepthMktDataDescriptionList[index]; }
        }

        public int Count
        {
            get { return DepthMktDataDescriptionList.Count; }
        }

        public object Add()
        {
            var rval = new ComDepthMktDataDescription();

            DepthMktDataDescriptionList.Add(rval);

            return rval;
        }
    }
}
