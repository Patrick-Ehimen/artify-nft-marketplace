import React from "react";
import Image from "next/image";
import Link from "next/link";
import { DiJqueryLogo } from "react-icons/di";
import {
  TiSocialFacebook,
  TiSocialLinkedin,
  TiSocialTwitter,
  TiSocialYoutube,
  TiSocialInstagram,
  TiArrowSortedDown,
  TiArrowSortedUp,
} from "react-icons/ti";
import { RiSendPlaneFill } from "react-icons/ri";

import Style from "./footer.module.css";
import images from "../../public/img";
import { Discover, HelpCenter } from "../navbar";

export default function footer() {
  return (
    <div className={Style.footer}>
      <div className={Style.footer_box}>
        <div className={Style.footer_box_social}>
          <Link href="/">
            <Image
              src={images.logo}
              alt="footer logo"
              height={50}
              width={50}
              className={Style.footer_box_social_logo}
            />
          </Link>
          <p>
            The world’s first and largest digital marketplace for crypto
            collectibles and non-fungible tokens (NFTs). Buy, sell, and discover
            exclusive digital items.
          </p>

          <div className={Style.footer_social}>
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

        <div className={Style.footer_box_discover}>
          <h3>Discover</h3>
          <Discover />
        </div>

        <div className={Style.footer_box_help}>
          <h3>Help Center</h3>
          <HelpCenter />
        </div>

        <div className={Style.subscribe}>
          <h3>Subscribe</h3>

          <div className={Style.subscribe_box}>
            <input type="email" placeholder="Enter your email *" />
            <RiSendPlaneFill className={Style.subscribe_box_send} />
          </div>
          <div className={Style.subscribe_box_info}>
            <p>
              Discover, collect, and sell extraordinary NFTs OpenSea is the
              world first and largest NFT marketplace
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
