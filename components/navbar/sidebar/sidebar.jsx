"use client";

import React, { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/router";
import { GrClose } from "react-icons/gr";
import {
  TiSocialFacebook,
  TiSocialLinkedin,
  TiSocialTwitter,
  TiSocialYoutube,
  TiSocialInstagram,
  TiArrowSortedDown,
  TiArrowSortedUp,
} from "react-icons/ti";
import { DiJqueryLogo } from "react-icons/di";

import Style from "./sideBar.module.css";
import images from "../../../public/img";
import Button from "../../button/button";

import { discover, helpCenter } from "../../../constants";

export default function Sidebar({
  setOpenSideMenu,
  currentAccount,
  connectWallet,
}) {
  const [openDiscover, setOpenDiscover] = useState(false);
  const [openHelp, setOpenHelp] = useState(false);

  const openDiscoverMenu = () => {
    if (!openDiscover) {
      setOpenDiscover(true);
    } else {
      setOpenDiscover(false);
    }
  };

  const openHelpMenu = () => {
    if (!openHelp) {
      setOpenHelp(true);
    } else {
      setOpenHelp(false);
    }
  };

  const closeSideBar = () => {
    setOpenSideMenu(false);
  };

  return (
    <div className={Style.sideBar}>
      <GrClose
        className={Style.sideBar_closeBtn}
        onClick={() => closeSideBar()}
      />
      <div className={Style.sideBar_box}>
        <Image src={images.logo} alt="logo" width={150} height={150} />
        <p>
          Discover the most outstanding articles on all topices of NFT & write
          your own stories and share them
        </p>
        <div className={Style.sideBar_social}>
          {[
            TiSocialFacebook,
            TiSocialLinkedin,
            TiSocialTwitter,
            TiSocialYoutube,
            TiSocialInstagram,
          ].map((Icon, index) => (
            <a key={index} href="#">
              <Icon />
            </a>
          ))}
        </div>
      </div>

      <div className={Style.sideBar_menu}>
        {[
          { title: "Discover", content: discover, isOpen: openDiscover },
          { title: "Help Center", content: helpCenter, isOpen: openHelp },
        ].map(({ title, content, isOpen }, index) => (
          <div key={index}>
            <div
              className={Style.sideBar_menu_box}
              onClick={() =>
                index === 0 ? openDiscoverMenu() : openHelpMenu()
              }
            >
              <p>{title}</p>
              <TiArrowSortedDown />
            </div>

            {isOpen && (
              <div className={Style.sideBar_discover}>
                {content.map((el, i) => (
                  <p key={i + 1}>
                    <Link href={{ pathname: `${el.link}` }}>{el.name}</Link>
                  </p>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>

      <div className={Style.sideBar_button}>
        <Button btnName="connect" handleClick={() => connectWallet()} />
        {/* <Button
          btnName="Create"
          handleClick={() => router.push("/uploadNFT")}
        /> */}

        <Button btnName="Connect Wallet" handleClick={() => {}} />
      </div>
    </div>
  );
}
